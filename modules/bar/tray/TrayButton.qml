// modules/bar/TrayButton.qml
import QtQuick
import QtQuick.Shapes
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.SystemTray

import qs.util

Item {
    id: trayButton
    implicitWidth: parent.implicitHeight
    implicitHeight: parent.implicitHeight
    visible: SystemTray?.items?.values?.length > 0

    rotation: StateStore.trayOpen ? 180 : 0

    Rectangle {
        anchors.fill: parent
        color: mouseArea.containsMouse ? Qt.lighter(Colors.md3.surface_container, 1.25) : Colors.md3.surface_container
    }

    Shape {
        anchors.centerIn: parent
        width: 12
        height: 5

        ShapePath {
            fillColor: "white"
            strokeWidth: 0

            startX: 0; startY: 0
            PathLine { x: 10; y: 0 }
            PathLine { x: 5;  y: 6 }
            PathLine { x: 0;  y: 0 }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: StateStore.trayOpen = !StateStore.trayOpen
        hoverEnabled: true
    }
}
