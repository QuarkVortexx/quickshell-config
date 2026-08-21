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
import "ws_indicator"

import qs.util

PanelWindow {
    id: root

    color: Colors.md3.surface
    implicitHeight: 32

    screen: ScreenManager.primaryScreen

    visible: StateStore.barOpen

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

        WorkspaceIndicator {
            Layout.fillHeight: true
        }

        // --- Bar Section (fills remaining space)
        Taskbar {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        // --- Tray button (right side)
        TrayButton {
            id: trayButton
            Layout.fillHeight: true
        }

        // --- System Indicators (right side)
        SystemIndicators { 
            id: systemIndicators
            Layout.fillHeight: true
        }

        // --- Clock Section (right side)
        Clock { 
            id: clock
            Layout.fillHeight: true
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
