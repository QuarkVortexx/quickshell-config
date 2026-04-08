import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

import "taskbar"
import "tray"
import "system_indicators"
import "system_indicators/system_panel"
import "clock"
import "clock/panels"

import qs.util

PanelWindow {
    id: root

    color: Colors.md3.surface
    implicitHeight: 32

    anchors {
        top: true
        left: true
        right: true
    }

    // Main horizontal layout
    RowLayout {
        anchors.fill: parent
        anchors.top: parent.top
        spacing: 0

        // --- Bar Section (fills remaining space)
        Taskbar {
            Layout.fillWidth: true
        }

        // --- Tray button (right side)
        TrayButton {
            id: trayButton
        }

        // --- System Indicators (right side)
        SystemIndicators { 
            id: systemIndicators
        }

        // --- Clock Section (right side)
        Clock { 
            id: clock
        }
    }

    // Bar popups
    TrayPanel {
        id: trayPanel
        anchor.window: root
        anchor.rect.x: trayButton.x + trayButton.width / 2 - width / 2
        anchor.rect.y: root.height + 5
    }

    SystemPanel {
        id: systemPanel
        anchor.window: root
        anchor.rect.x: root.width - systemIndicators.width / 2 - width / 2
        anchor.rect.y: root.height + 5
    }

    CalendarPanel {
        id: calendarPanel
        anchor.window: root
        anchor.rect.x: root.width - clock.width / 2 - width / 2
        anchor.rect.y: root.height + 5
    }
}
