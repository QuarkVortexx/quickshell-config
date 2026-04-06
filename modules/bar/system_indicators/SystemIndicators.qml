// modules/bar/SystemIndicators.qml
import QtQuick
import QtQuick.Shapes
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Pipewire

import qs.util

Item {
    id: systemIndicators

    implicitHeight: parent.implicitHeight
    implicitWidth: indicatorRow.implicitWidth + indicatorRow.anchors.leftMargin + indicatorRow.anchors.rightMargin

    Rectangle {
        anchors.fill: parent
        color: mouseArea.containsMouse ? Qt.lighter(Colors.palette.primary50, 1.1) : Colors.palette.primary50
    }

    RowLayout {
        id: indicatorRow
        anchors.fill: parent
        anchors.leftMargin: parent.implicitHeight / 5
        anchors.rightMargin: parent.implicitHeight / 5
        spacing: 3

        MicIndicator {
            clickable: false
        }

        VolumeIndicator {
            clickable: false;
        }

        NetworkIndicator { }

        BatteryIndicator { }

        NotificationIndicator { }
    }

    // MouseArea only responds if clickable is true
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: StateStore.systemPanelOpen = !StateStore.systemPanelOpen
        hoverEnabled: true
    }
}
