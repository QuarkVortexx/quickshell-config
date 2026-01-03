import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

PanelWindow {
    id: root

    color: "#2B2725" // dark background
    implicitHeight: 30

    anchors {
        top: true
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

        // --- Tray button (right side)
        TrayButton { }

        // --- MicIndicator (right side)
        SystemIndicators { }

        // --- Clock Section (right side)
        Clock { }
    }
}
