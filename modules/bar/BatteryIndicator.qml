// modules/bar/BatteryIndicator.qml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.UPower

Item {
    id: batteryIndicator

    readonly property var device: UPower.displayDevice
    visible: UPower.onBattery && device && device.ready

    // Layout-friendly sizing
    implicitWidth: contentRow.implicitWidth + 10
    implicitHeight: 18
    width: implicitWidth
    height: implicitHeight

    // Thresholds
    readonly property int lowThreshold: 15
    readonly property int mediumThreshold: 30

    // Derived state
    readonly property int percentage: Math.round(device?.percentage * 100 ?? 0)

    readonly property color batteryColor: {
        if (percentage <= lowThreshold)
            return "#ff0000"   // red
        else if (percentage <= mediumThreshold)
            return "#ff0"   // yellow
        else
            return "#00ff00"   // green
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
        radius: height / 2
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
            color: "black"
        }

        Text {
            text: percentage
            font.pixelSize: 10
            font.weight: Font.Medium
            color: "black"
        }
    }
}
