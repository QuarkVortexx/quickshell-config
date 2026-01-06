import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.Pipewire 

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes

import qs.util

PanelWindow {
    id: systemPanel

    visible: StateStore.systemPanelOpen
    color: "transparent"

    anchors {
        top: true
        right: true
    }

    margins {
        top: 10
        right: 10
    }

    implicitWidth: 350
    implicitHeight: systemPanelColumn.implicitHeight + systemPanelColumn.anchors.margins * 2

    Connections {
        target: AudioService
        function onVolumeChanged() {
            volumeSlider.value = AudioService.volume
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#2A2524"
        radius: 10
        border.color: "#3A3534"
        border.width: 2
    }

    ColumnLayout {
        id: systemPanelColumn
        anchors.fill: parent
        anchors.margins: 10
        spacing: 5

        RowLayout {
            id: wifiRow
            spacing: 2

            WifiButton {
                height: 36
                Layout.fillWidth: true
            }

            Item {
                id: wifiButton
                width: 18
                height: 18
                rotation: 270

                Rectangle {
                    anchors.fill: parent
                    radius: 3
                    color: "#373533"
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
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Quickshell.execDetached(["foot", "-e", "wlctl"])
                }
            }
        }

        RowLayout {
            id: bluetoothRow
            spacing: 2

            BluetoothButton {
                height: 36
                Layout.fillWidth: true
            }

            Item {
                id: bluetoothButton
                width: 18
                height: 18
                rotation: 270

                Rectangle {
                    anchors.fill: parent
                    radius: 3
                    color: "#373533"
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
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Quickshell.execDetached(["foot", "-e", "bluetui"])
                }
            }
        }

        RowLayout {
            id: buttonsRow
            spacing: 2

                MicIndicator {
                    height: 36
                    Layout.fillWidth: true
                }

                VolumeIndicator {
                    height: 36
                    Layout.fillWidth: true
                }

            Item {
                id: wiremixButton
                width: 18
                height: 18
                rotation: 270

                Rectangle {
                    anchors.fill: parent
                    radius: 3
                    color: "#373533"
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
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Quickshell.execDetached(["foot", "-e", "wiremix"])
                }
            }
        }

        RowLayout {
            id: sliderRow
            spacing: 2

            CustomSlider {
                id: volumeSlider
                value: AudioService.volume
                height: 36
                Layout.fillWidth: true
                onValueChanged: {
                    AudioService.setVolume(value)
                }
            }
        }
    }

    Connections {
        target: StateStore
        function onSystemPanelOpenChanged() {
            systemPanelFocusGrab.active = StateStore.systemPanelOpen;
        }
    }

    HyprlandFocusGrab {
        id: systemPanelFocusGrab
        windows: [systemPanel]
        active: false
        onCleared: () => {
            StateStore.systemPanelOpen = false;
        }
    }
}
