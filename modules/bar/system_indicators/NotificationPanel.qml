import QtQuick
import QtQuick.Layouts
import QtQuick.Controls 
import Quickshell
import qs.util

Item {
    width: 400
    height: 300  // Fixed panel height

    Rectangle {
        anchors.fill: parent
        color: Colors.md3.surface_variant

        Column {
            anchors.fill: parent
            anchors.margins: 8
            spacing: 8

            RowLayout {
                id: notifRow
                spacing: 8
                width: parent.width

                Text {
                    text: "Notifications: " + NotificationService?.count()
                    font.pixelSize: 20
                    font.weight: Font.Bold
                    color: Colors.md3.on_surface_variant
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

            // Scrollable list of notifications
            ScrollView {
                id: scrollView
                width: parent.width
                height: parent.height - notifRow.height - parent.spacing
                ListView {
                    id: listView
                    model: NotificationService?.all()
                    spacing: 5
                    anchors.fill: parent
                    clip: true

                    delegate: Rectangle {
                        id: notificationRoot
                        width: parent.width
                        color: Colors.md3.primary_container
                        border.color: Qt.lighter(Colors.md3.primary_container, 1.5)
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
                            anchors.margins: 15
                            spacing: 6
                            clip: true

                            /* ───── Top row: icon + app name | dismiss ───── */
                            RowLayout {
                                width: parent.width
                                spacing: 6

                                // App icon (optional)
                                Image {
                                    visible: modelData.appIcon && modelData.appIcon !== ""
                                    source: Quickshell.iconPath(modelData.appIcon ?? "foot")
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
                                    font.pixelSize: 13
                                    color: Colors.md3.on_primary_container
                                    elide: Text.ElideRight
                                    Layout.alignment: Qt.AlignVCenter
                                }

                                // Spacer pushes dismiss button right
                                Item {
                                    Layout.fillWidth: true
                                }

                                // Custom dismiss button
                                Item {
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

                            /* ───── Summary (title) ───── */
                            Text {
                                text: modelData.summary
                                font.pixelSize: 16
                                font.weight: Font.Bold
                                color: Colors.md3.on_primary_container
                                wrapMode: Text.Wrap
                                width: parent.width
                            }

                            /* ───── Body ───── */
                            Text {
                                visible: modelData.body && modelData.body !== ""
                                text: modelData.body
                                font.pixelSize: 14
                                color: Colors.md3.on_primary_container
                                wrapMode: Text.Wrap
                                width: parent.width
                            }
                        }
                    }
                }
            }
        }
    }
}
