import QtQuick
import QtQuick.Layouts
import QtQuick.Controls 
import Quickshell
import qs.util

Item {
    readonly property int fullHeight: listView.height + notifRowBg.height + mainColumn.anchors.margins * 2 + mainColumn.spacing
    readonly property int titleHeight: notifRowBg.height + mainColumn.anchors.margins * 2
    implicitHeight: listView.visible? fullHeight  : titleHeight

    Rectangle {
        anchors.fill: parent
        color: Colors.md3.surface
        border.color: Qt.lighter(Colors.md3.surface, 2.0)
        border.width: 2

        Column {
            id: mainColumn
            anchors.fill: parent
            anchors.margins: 8
            spacing: 8

            Rectangle {
                id: notifRowBg
                color: Colors.md3.surface_container
                border.color: Qt.lighter(Colors.md3.surface_container, 1.5)
                border.width: 1
                width: parent.width
                height: 50

                RowLayout {
                    id: notifRow
                    spacing: 8
                    width: parent.width
                    anchors.fill: parent
                    anchors.margins: 10

                    Text {
                        text: NotificationService?.count() ? "Notifications " + NotificationService.count() : "No Notifications"
                        font.pixelSize: 20
                        font.weight: Font.Bold
                        color: Colors.md3.on_surface
                        Layout.alignment: Qt.AlignVCenter
                    }

                    // Spacer pushes items apart
                    Item {
                        Layout.fillWidth: true
                    }

                    Item {
                        id: clearAllButton
                        width: 32
                        height: 32
                        Layout.alignment: Qt.AlignVCenter
                        visible: NotificationService?.count() > 0

                        MouseArea {
                            anchors.fill: parent
                            onClicked: NotificationService?.clear()
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                        }

                        Rectangle {
                            anchors.fill: parent
                            color: Colors.md3.primary
                        }

                        Text {
                            text: "󰎟"
                            color: Colors.md3.on_primary
                            font.pixelSize: 28
                            anchors.centerIn: parent
                        }
                    }
                }
            }

            // Scrollable list of notifications
            ListView {
                id: listView
                model: NotificationService?.all()
                spacing: 5
                width: parent.width
                height: Math.min(contentHeight, 500)
                clip: true
                visible: NotificationService?.count() > 0
                delegate: Rectangle {
                    id: notificationRoot
                    implicitWidth: parent?.width || 0
                    color: Colors.md3.surface_container
                    border.color: Qt.lighter(Colors.md3.surface_container, 1.5)
                    border.width: 1

                    // Dynamic height
                    implicitHeight: content.implicitHeight + content.anchors.margins * 2

                    readonly property var desktopEntry: DesktopEntries.heuristicLookup(modelData.desktopEntry)

                    MouseArea {
                        visible: desktopEntry?.execString !== ""
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: desktopEntry.execute()
                    }

                    Column {
                        id: content
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 5
                        clip: true

                        /* ───── Top row: icon + app name | dismiss ───── */
                        RowLayout {
                            id: topRow
                            spacing: 6
                            width: parent.width
                            anchors.margins: 5

                            // App icon (optional)
                            Image {
                                id: appIcon
                                visible: modelData.appIcon && modelData.appIcon !== ""
                                source: Quickshell.iconPath(modelData?.appIcon ?? "foot")
                                width: 24
                                height: 24
                                sourceSize: Qt.size(24, 24)
                                smooth: true
                                fillMode: Image.PreserveAspectFit
                                Layout.alignment: Qt.AlignVCenter
                            }

                            // App name (optional)
                            Text {
                                visible: (modelData.appName && modelData.appName !== "") || (moduleData.desktopEntry && modelData.desktopEntry !== "")
                                text: modelData.appName || desktopEntry?.name || modelData.desktopEntry
                                font.pixelSize: 18
                                font.weight: Font.DemiBold
                                color: Colors.md3.on_surface
                                elide: Text.ElideRight
                                Layout.alignment: Qt.AlignVCenter
                                Layout.maximumWidth: parent.width - appIcon.width - dismissButton.width - topRow.spacing - topRow.anchors.margins * 2
                                wrapMode: Text.NoWrap
                            }

                            // Spacer pushes dismiss button right
                            Item {
                                Layout.fillWidth: true
                            }

                            // Custom dismiss button
                            Item {
                                id: dismissButton
                                width: 20
                                height: 20
                                Layout.alignment: Qt.AlignVCenter

                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: modelData.dismiss()
                                }

                                Rectangle {
                                    anchors.fill: parent
                                    color: Colors.md3.primary
                                }

                                Text {
                                    text: ""
                                    color: Colors.md3.on_primary
                                    font.pixelSize: 14
                                    anchors.centerIn: parent
                                }
                            }
                        }

                        /* divider */
                        Rectangle {
                            width: parent.width
                            height: 2
                            color: Colors.md3.outline
                        }

                        /* ───── Summary (title) ───── */
                        Text {
                            text: modelData.summary
                            font.pixelSize: 16
                            font.weight: Font.Medium
                            color: Colors.md3.on_surface
                            wrapMode: Text.Wrap
                            width: parent.width
                        }

                        /* ───── Body ───── */
                        Text {
                            visible: modelData.body && modelData.body !== ""
                            text: modelData.body
                            font.pixelSize: 14
                            font.weight: Font.Light
                            color: Colors.md3.on_surface
                            wrapMode: Text.Wrap
                            width: parent.width
                        }
                    }
                }
            }
        }
    }
}
