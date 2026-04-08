import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.Pipewire 

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes

import qs.util

import "buttons"
import "panels"

PopupWindow {
    id: systemPanel

    visible: StateStore.systemPanelOpen
    color: "transparent"

    implicitWidth: quickSettingsPanel.implicitWidth + systemPanelColumn.anchors.margins * 2
    implicitHeight: systemPanelColumn.implicitHeight + systemPanelColumn.anchors.margins * 2

    ColumnLayout {
        id: systemPanelColumn
        anchors.fill: parent
        spacing: 5

        QuickSettingsPanel {
            id: quickSettingsPanel
            width: parent.width
        }

        NotificationPanel {
            width: parent.width
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
