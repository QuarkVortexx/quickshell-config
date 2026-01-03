// modules/bar/WifiButton.qml
import QtQuick
import QtQuick.Shapes
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Pipewire

import qs.util

Item {
    id: wifiButton
    height: 18
    width: 282

    readonly property bool wifiEnabled: NetworkService.wifiEnabled;

    readonly property string wifiText: wifiEnabled ? "Enabled: 󰤨" :  "Disabled: 󰤭";

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
        radius: 9
        color: !wifiEnabled ? "#ff0000" : "#00ff00"
    }

    Text {
        id: networkIcon
        anchors.centerIn: parent
        
        text: wifiText
        
        font.pixelSize: 15      
        color: "black"
    }
}
