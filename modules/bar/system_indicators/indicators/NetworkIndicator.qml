// modules/bar/NetworkIndicator.qml
import QtQuick
import QtQuick.Shapes
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Pipewire

import qs.util

Item {
    id: networkIndicator
    width: 24
    height: 24

    readonly property bool connected: NetworkService.connected
    readonly property int wifiSignal: NetworkService.wifiSignal

    Rectangle {
        anchors.fill: parent
        color: !connected ? Colors.md3.error : "transparent"
    }

    Text {
        id: networkIcon
        anchors.centerIn: parent
        
        text: {
            if (NetworkService.wiredActive) return "󰈁"
            if (NetworkService.wifiActive) {
                if (wifiSignal >= 80) return "󰤨"
                if (wifiSignal >= 60) return "󰤥"
                if (wifiSignal >= 40) return "󰤢"
                if (wifiSignal >= 20) return "󰤟"
                return "󰤯"
            }
            return "󰈂"
        }
        
        font.pixelSize: 15      
        color: !connected ? Colors.md3.on_error : Colors.md3.on_surface
    }
}
