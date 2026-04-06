import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.SystemTray

import QtQuick
import QtQuick.Controls

import qs.util

PopupWindow {
    id: trayPanel

    readonly property var trayItems: SystemTray.items.values
    // readonly property var trayItems: [].concat.apply([], Array(2).fill(SystemTray.items.values)) // For testing overflow, adjust the multiplier as needed

    readonly property int buttonScale: 3
    readonly property int trayButtonSize: 12 * buttonScale
    readonly property int trayItemsPerRow: Math.min(4, trayItems.length)

    visible: StateStore.trayOpen && trayItems.length > 0
    color: "transparent"

    // Size adapts to content
    implicitWidth: (trayButtonSize * trayItemsPerRow) + trayFlow.anchors.margins * 2 + (trayFlow.spacing * (trayItemsPerRow - 1))
    implicitHeight: trayFlow.implicitHeight + trayFlow.anchors.margins * 2

    Rectangle {
        anchors.fill: parent
        color: Colors.md3.surface
        border.color: Qt.lighter(Colors.md3.surface, 2.0)
        border.width: 2

        Flow {
            id: trayFlow
            anchors.fill: parent
            anchors.margins: trayButtonSize / 4
            spacing: anchors.margins / 3
            flow: Flow.LeftToRight
            layoutDirection: Qt.LeftToRight

            Repeater {
                model: trayItems

                delegate: Rectangle {
                    id: trayButton
                    required property var modelData

                    width: trayButtonSize
                    height: trayButtonSize
                    color: hovered ? Qt.lighter(Colors.md3.surface, 2.0) : "transparent"

                    property bool hovered: false

                    Image {
                        anchors.centerIn: parent
                        source: modelData.icon
                        width: trayButtonSize * 0.6
                        height: trayButtonSize * 0.6
                        smooth: true
                    }

                    QsMenuAnchor {
                        id: menuAnchor
                        anchor.window: trayPanel
                        anchor.rect.x: trayButton.x + trayButton.width / 2 + trayFlow.spacing * 2
                        anchor.rect.y: trayButton.y + trayButton.height / 2 + trayFlow.spacing * 2
                        menu: modelData.menu

                        onOpened: trayPanelFocusGrab.active = false
                        onClosed: {
                            if (StateStore.trayOpen) {
                                trayPanelFocusGrab.active = true;
                            }
                            StateStore.trayOpen = false;
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true

                        onEntered: hovered = true
                        onExited: hovered = false

                        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

                        onClicked: (mouse) => {
                            if ((mouse.button === Qt.RightButton || modelData.onlyMenu) && modelData.hasMenu) {
                                menuAnchor.open();
                                return;
                            } else if (mouse.button === Qt.LeftButton) {
                                modelData.activate();
                            } else {
                                modelData.secondaryActivate();
                            }
                            StateStore.trayOpen = false;
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
        onCleared: () => StateStore.trayOpen = false;
    }
}