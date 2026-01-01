import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.SystemTray

import QtQuick
import QtQuick.Controls

import "../../util"

PanelWindow {
    id: trayPanel

    readonly property var trayItems: SystemTray.items.values

    visible: StateStore.trayOpen && trayItems.length > 0
    color: "transparent"

    anchors {
        top: true
        right: true
    }

    margins {
        top: 10
        right: 10
    }

    // Size adapts to content
    implicitWidth: trayGrid.implicitWidth + 12;
    implicitHeight: trayGrid.implicitHeight + 16;

    Rectangle {
        anchors.fill: parent
        color: "#2A2524"
        radius: 10
        border.color: "#3A3534"
        border.width: 2

        Grid {
            id: trayGrid
            anchors {
                fill: parent
                margins: 8
            }

            columns: 4
            spacing: 4

            Repeater {
                model: trayItems

                delegate: Rectangle {
                    id: trayButton

                    required property var modelData

                    width: 36
                    height: 36
                    radius: 6
                    color: hovered ? "#3A3534" : "#332E2D"

                    property bool hovered: false

                    Image {
                        anchors.centerIn: parent
                        source: modelData.icon
                        width: 20
                        height: 20
                        smooth: true
                    }

                    QsMenuAnchor {
                        id: menuAnchor
                        anchor.window: trayPanel
                        menu: modelData.menu

                        // Track when menu opens
                        onOpened: {
                            trayPanelFocusGrab.active = false   // do not grab while menu is open

                            const p = parent.mapToItem(
                                trayPanel.contentItem,
                                trayButton.width / 2,
                                trayButton.height / 2
                            )

                            const x = p.x;
                            const y = p.y;

                            anchor.rect.x = x;
                            anchor.rect.y = y;
                        }

                        // Track when menu closes
                        onClosed: {
                            trayPanelFocusGrab.active = true    // restore focus grab
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true

                        onEntered: hovered = true
                        onExited: hovered = false

                        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

                        onClicked: (mouse) => {
                            if (mouse.button === Qt.RightButton && modelData.hasMenu) {
                                menuAnchor.open();
                            } else if (mouse.button === Qt.LeftButton) {
                                modelData.activate();
                            }
                        }
                        onWheel: wheel => modelData.scroll(wheel.angleDelta.x, wheel.angleDelta.y)
                    }
                }
            }
        }
    }

    Connections {
        target: StateStore
        function onTrayOpenChanged() {
            trayPanelFocusGrab.active = StateStore.trayOpen;
        }
    }

    HyprlandFocusGrab {
        id: trayPanelFocusGrab
        windows: [trayPanel]
        active: false
        onCleared: () => {
            StateStore.trayOpen = false;
        }
    }
}
