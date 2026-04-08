// modules/bar/WifiButton.qml
import QtQuick
import QtQuick.Shapes
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Pipewire

import qs.util

Item {
    id: wifiButton

    readonly property bool wifiEnabled: NetworkService.wifiEnabled;
    readonly property int wifiSignal: NetworkService.wifiSignal;
    readonly property string connectionName: NetworkService.wifiName;

    readonly property string icon: {
        if (wifiSignal >= 80) return "󰤨"
        if (wifiSignal >= 60) return "󰤥"
        if (wifiSignal >= 40) return "󰤢"
        if (wifiSignal >= 20) return "󰤟"
        return "󰤯"
    }

    // MouseArea only responds if clickable is true
    MouseArea {
        anchors.fill: parent
        onClicked: {
            NetworkService.toggleWifi();
            NetworkService.refresh();
        }
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
    }

    Rectangle {
        anchors.fill: parent
        color: !wifiEnabled ? Colors.md3.error : !connectionName ? Colors.md3.warning : Colors.md3.primary
    }

    Row {
        anchors.centerIn: parent
        spacing: 12

        // Icon
        Text {
            text: icon
            font.pixelSize: wifiButton.height / 3
            color: !wifiEnabled ? Colors.md3.on_error : !connectionName ? Colors.md3.on_warning : Colors.md3.on_primary
            anchors.verticalCenter: parent.verticalCenter
        }

        // Title and Description
        Column {
            spacing: 2

            Text {
                text: connectionName || "Wi-Fi"
                font.pixelSize: 12
                font.bold: true
                color: !wifiEnabled ? Colors.md3.on_error : Colors.md3.on_primary
                width: wifiButton.width - wifiButton.height
                clip: true
            }
            Text {
                text: wifiEnabled ? connectionName ? "Connected" : "Enabled" : "Disabled"
                font.pixelSize: 10
                color: !wifiEnabled ? Colors.md3.on_error : Colors.md3.on_primary
            }
        }
    }
}
