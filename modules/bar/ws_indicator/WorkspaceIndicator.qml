import QtQuick
import Quickshell
import Quickshell.Hyprland 

import qs.util

Item {
    id: workspaceIndicator
    implicitWidth: workspaceText.width + workspaceText.anchors.leftMargin + workspaceText.anchors.rightMargin

    Text {
        id: workspaceText
        text: Hyprland?.focusedWorkspace?.name ?? ""
        font.pixelSize: 14
        color: Colors.md3.on_surface
        padding: 8
        anchors.centerIn: parent
    }
}