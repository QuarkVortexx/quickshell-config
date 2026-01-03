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
    width: 80
    implicitHeight: indicatorRow.implicitHeight + indicatorRow.anchors.margin * 2

    RowLayout {
        id: indicatorRow
        anchors.fill: parent
        anchors.centerIn: parent
        spacing: 3

        MicIndicator {
            clickable: false
        }

        VolumeIndicator {
            clickable: false;
        }
    }

    // MouseArea only responds if clickable is true
    MouseArea {
        anchors.fill: parent
        onClicked: StateStore.systemPanelOpen = !StateStore.systemPanelOpen
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
    }
}
