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
    height: 18

    // New property to control clickability
    property bool clickable: true

    readonly property bool connected: NetworkService.connected
    readonly property int wifiSignal: NetworkService.wifiSignal

    Rectangle {
        anchors.fill: parent
        radius: 9
        color: !connected ? "#ff0000" : "#00ff00"
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
        color: black
    }
}
