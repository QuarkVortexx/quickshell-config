import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

PanelWindow {
    id: root

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
        anchors.fill: parent
        anchors.margins: 5
        spacing: 8

        // --- Bar Section (fills remaining space)
        Taskbar {
            Layout.fillWidth: true
        }

        // --- Clock Section (right side)
        Clock { }
    }
}
