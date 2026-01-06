// modules/bar/BluetoothButton.qml
import QtQuick
import QtQuick.Shapes
import Quickshell

import qs.util

Item {
    id: bluetoothButton
    height: 18
    width: 282

    readonly property bool bluetoothPowered: BluetoothService.powered;
    readonly property bool bluetoothConnected: BluetoothService.connected

    readonly property string connectedString: BluetoothService.connectedCount === 1 ? "1 device" : `${BluetoothService.connectedCount} devices`

    readonly property string bluetoothText: bluetoothPowered ? bluetoothConnected ? `Connected: 󰂱 | ${connectedString}` : "Enabled: " : "Disabled: 󰂲"

    // MouseArea only responds if clickable is true
    MouseArea {
        anchors.fill: parent
        onClicked: {
            BluetoothService.togglePower();
            BluetoothService.refresh();
        }
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
    }

    Rectangle {
        anchors.fill: parent
        radius: 9
        color: bluetoothPowered ? bluetoothConnected ? "#00ff00" : "#ff0" : "#ff0000"
    }

    Text {
        id: bluetoothIcon
        anchors.centerIn: parent
        
        text: bluetoothText
        
        font.pixelSize: 15      
        color: "black"
    }
}
