// BatteryButton.qml
import QtQuick
import Quickshell
import Quickshell.Services.UPower
import qs.util

Item {
    id: batteryButton

    readonly property var device: UPower.displayDevice
    readonly property bool isReady: device?.ready
    readonly property bool onBattery: UPower?.onBattery
    readonly property int percentage: Math.round(device?.percentage * 100 ?? 0)

    // Thresholds
    readonly property int lowThreshold: 15
    readonly property int mediumThreshold: 30

    // Derived state
    readonly property color batteryColor: {
        if (percentage <= lowThreshold)
            return Colors.md3.error
        else if (percentage <= mediumThreshold)
            return Colors.md3.warning
        else
            return Colors.md3.primary
    }

    readonly property color textColor: {
        if (percentage <= lowThreshold)
            return Colors.md3.on_error
        else if (percentage <= mediumThreshold)
            return Colors.md3.on_warning
        else
            return Colors.md3.on_primary
    }

    readonly property string batteryIcon: {
        if (percentage <= 10) return ""
        if (percentage <= 25) return ""
        if (percentage <= 50) return ""
        if (percentage <= 75) return ""
        return ""
    }

    Rectangle {
        anchors.fill: parent
        color: batteryColor
    }

    Row {
        anchors.centerIn: parent
        spacing: 12

        // Icon
        Text {
            text: batteryIcon
            font.pixelSize: batteryButton.height / 3
            color: textColor
            rotation: 270
            anchors.verticalCenter: parent.verticalCenter
        }

        // Title and Description
        Column {
            spacing: 2
            Text {
                text: isReady ? !onBattery ? "Charging" : "Discharging" : "No Battery"
                font.pixelSize: 12
                font.bold: true
                color: textColor
            }
            Text {
                text: isReady ? `${percentage}%` : "??"
                font.pixelSize: 10
                color: textColor
            }
        }
    }
}