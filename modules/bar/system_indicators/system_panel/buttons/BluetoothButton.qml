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
        color: bluetoothPowered ? bluetoothConnected ? Colors.md3.primary : Colors.md3.tertiary : Colors.md3.error
    }

    Text {
        id: bluetoothIcon
        anchors.centerIn: parent
        
        text: bluetoothText
        
        font.pixelSize: 15      
        color: bluetoothPowered ? bluetoothConnected ? Colors.md3.on_primary : Colors.md3.on_tertiary : Colors.md3.on_error
    }
}
