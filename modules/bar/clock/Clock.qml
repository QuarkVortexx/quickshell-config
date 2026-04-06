import QtQuick
import QtQuick.Layouts

import qs.util

Item {
    implicitWidth: clockText.width + clockText.anchors.leftMargin + clockText.anchors.rightMargin
    implicitHeight: parent.height

    Rectangle {
        anchors.fill: parent
        color: Colors.palette.primary60
    }

    Text {
        id: clockText
        text: TimeService.format("hh:mm:ss")
        color: Colors.md3.on_primary
        font.pixelSize: 14
        anchors.leftMargin: parent.implicitHeight / 4
        anchors.rightMargin: parent.implicitHeight / 4
        anchors.centerIn: parent
    }
}