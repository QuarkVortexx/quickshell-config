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
    height: 24

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
        color: !AudioService.sourceReady ? Colors.md3.tertiary : AudioService.sourceMuted ? Colors.md3.error : Colors.md3.primary
    }

    Text {
        id: label
        text: !AudioService.sourceReady ? "󱦉" : AudioService.sourceMuted ? "󰍭" : "󰍬"
        color: !AudioService.sourceReady ? Colors.md3.on_tertiary : AudioService.sourceMuted ? Colors.md3.on_error : Colors.md3.on_primary
        font.pixelSize: 15
        anchors.centerIn: parent
    }
}
