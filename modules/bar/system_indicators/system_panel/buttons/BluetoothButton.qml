// modules/bar/BluetoothButton.qml
import QtQuick
import QtQuick.Shapes
import Quickshell

import qs.util

Item {
    id: bluetoothButton

    readonly property bool bluetoothPowered: BluetoothService.powered;
    readonly property bool bluetoothConnected: BluetoothService.connected

    readonly property string connectedString: `${BluetoothService.connectedCount}`

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
        color: bluetoothPowered ? bluetoothConnected ? Colors.md3.primary : Colors.md3.warning : Colors.md3.error
    }

    Row {
        anchors.centerIn: parent
        spacing: 12

        // Icon
        Text {
            text: bluetoothPowered ? (bluetoothConnected ? "󰂱" : "") : "󰂲"
            font.pixelSize: bluetoothButton.height / 3
            color: bluetoothPowered ? (bluetoothConnected ? Colors.md3.on_primary : Colors.md3.on_warning) : Colors.md3.on_error
            anchors.verticalCenter: parent.verticalCenter
        }

        // Title and Description
        Column {
            spacing: 2

            Text {
                text: "Bluetooth"
                font.pixelSize: 12
                font.bold: true
                color: bluetoothPowered ? (bluetoothConnected ? Colors.md3.on_primary : Colors.md3.on_warning) : Colors.md3.on_error
            }
            Text {
                text: bluetoothPowered
                    ? (bluetoothConnected
                        ? `Connected (${connectedString})`
                        : "Enabled")
                    : "Disabled"
                font.pixelSize: 10
                color: bluetoothPowered ? (bluetoothConnected ? Colors.md3.on_primary : Colors.md3.on_warning) : Colors.md3.on_error
            }
        }
    }
}
