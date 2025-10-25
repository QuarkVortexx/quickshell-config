import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

import "modules/bar"

Scope {
    id: root
    property string time

    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData

            color: "#2B2725" // dark background
            implicitHeight: 46

            anchors {
              bottom: true
              left: true
              right: true
            }

            // Main horizontal layout
            RowLayout {
                id: barLayout
                anchors.fill: parent
                anchors.margins: 5
                spacing: 8

                // --- Bar Section (fills remaining space)
                Bar {
                    id: taskBar
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.alignment: Qt.AlignVCenter
                }

                // --- Clock Section (right side)
                Text {
                    id: clockText
                    text: root.time.trim()
                    color: "white"
                    font.pixelSize: 14
                    Layout.alignment: Qt.AlignVCenter
                }
            }
        }
    }

    // --- Clock process ---
    Process {
        id: dateProc
        command: ["date", "+%H:%M:%S"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: root.time = this.text
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: dateProc.running = true
    }
}
