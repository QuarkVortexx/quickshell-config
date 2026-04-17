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

    Rectangle {
        anchors.fill: parent
        color: !AudioService.sourceReady ? Colors.md3.warning : AudioService.sourceMuted ? Colors.md3.error : "transparent"
    }

    Text {
        id: label
        text: !AudioService.sourceReady ? "󱦉" : AudioService.sourceMuted ? "󰍭" : "󰍬"
        color: !AudioService.sourceReady ? Colors.md3.on_warning : AudioService.sourceMuted ? Colors.md3.on_error : Colors.md3.on_surface
        font.pixelSize: 15
        anchors.centerIn: parent
    }
}
