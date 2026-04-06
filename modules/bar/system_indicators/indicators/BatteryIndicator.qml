// modules/bar/BatteryIndicator.qml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.UPower

import qs.util

Item {
    id: batteryIndicator

    readonly property var device: UPower.displayDevice
    visible: true // UPower.onBattery && device && device.ready

    // Layout-friendly sizing
    implicitWidth: contentRow.implicitWidth + 10
    implicitHeight: 24
    width: implicitWidth
    height: implicitHeight

    // Thresholds
    readonly property int lowThreshold: 15
    readonly property int mediumThreshold: 30

    // Derived state
    readonly property int percentage: Math.round(device?.percentage * 100 ?? 0)

    readonly property color batteryColor: {
        if (percentage <= lowThreshold)
            return Colors.md3.error
        else if (percentage <= mediumThreshold)
            return Colors.md3.tertiary
        else
            return Colors.md3.primary
    }

    readonly property color textColor: {
        if (percentage <= lowThreshold)
            return Colors.md3.on_error
        else if (percentage <= mediumThreshold)
            return Colors.md3.on_tertiary
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

    RowLayout {
        id: contentRow
        anchors.centerIn: parent
        anchors.margins: 5
        spacing: 3

        Text {
            text: batteryIcon
            font.pixelSize: 14
            color: textColor
        }

        Text {
            text: percentage
            font.pixelSize: 10
            font.weight: Font.Medium
            color: textColor
        }
    }
}
