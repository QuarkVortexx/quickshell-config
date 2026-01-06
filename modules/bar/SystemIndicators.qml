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

    implicitWidth: indicatorRow.implicitWidth + indicatorRow.anchors.margins * 2
    implicitHeight: indicatorRow.implicitHeight + indicatorRow.anchors.margins * 2

    width: implicitWidth
    height: implicitHeight

    RowLayout {
        id: indicatorRow
        spacing: 3

        MicIndicator {
            clickable: false
        }

        VolumeIndicator {
            clickable: false;
        }

        NetworkIndicator { }

        BatteryIndicator { }
    }

    // MouseArea only responds if clickable is true
    MouseArea {
        anchors.fill: parent
        onClicked: StateStore.systemPanelOpen = !StateStore.systemPanelOpen
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
    }
}
