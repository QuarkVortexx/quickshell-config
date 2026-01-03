// modules/bar/MicIndicator.qml
import QtQuick
import QtQuick.Shapes
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Pipewire

import qs.util

Item {
    id: micIndicator
    width: 24
    height: 18

    // New property to control clickability
    property bool clickable: true

    // MouseArea only responds if clickable is true
    MouseArea {
        anchors.fill: parent
        enabled: micIndicator.clickable
        onClicked: {
            AudioService.toggleSourceMute();
        }
        hoverEnabled: true
        cursorShape: micIndicator.clickable ? Qt.PointingHandCursor : Qt.ArrowCursor
    }

    Rectangle {
        anchors.fill: parent
        radius: 9
        color: !AudioService.sourceReady ? "#ff0" : AudioService.sourceMuted ? "#ff0000" : "#00ff00"
    }

    Text {
        id: label
        text: !AudioService.sourceReady ? "󱦉" : AudioService.sourceMuted ? "󰍭" : "󰍬"
        color: "black"
        font.pixelSize: 15
        anchors.centerIn: parent
    }
}
