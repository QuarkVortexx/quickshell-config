import QtQuick
import QtQuick.Layouts

import qs.util

Item {
    implicitWidth: clockText.width + clockText.anchors.leftMargin + clockText.anchors.rightMargin
    implicitHeight: parent.height

    Rectangle {
        anchors.fill: parent
        color: mouseArea.containsMouse ? Qt.lighter(Colors.md3.surface_container_highest, 1.25) : Colors.md3.surface_container_highest
    }

    Text {
        id: clockText
        text: TimeService.format("hh:mm:ss")
        color: Colors.md3.on_surface
        font.pixelSize: 14
        anchors.leftMargin: parent.implicitHeight / 4
        anchors.rightMargin: parent.implicitHeight / 4
        anchors.centerIn: parent
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true
        onClicked: {
            StateStore.calendarOpen = !StateStore.calendarOpen
        }
    }
}