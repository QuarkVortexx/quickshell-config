// modules/bar/MicIndicator.qml
import QtQuick
import QtQuick.Shapes
import QtQuick.Layouts
import Quickshell

import qs.util

Item {
    id: notificationIndicator
    implicitWidth: notifRow.implicitWidth + notifRow.anchors.margins * 2
    height: 24

    readonly property var notifCount: NotificationService.count();

    visible: notifCount > 0

    Rectangle {
        anchors.fill: parent
        color: Colors.md3.tertiary
    }

    RowLayout {
        id: notifRow
        anchors.centerIn: parent
        anchors.margins: 5
        spacing: 3
        
        Text {
            id: notifIcon
            
            text: "󰂚"
            font.pixelSize: 15      
            color: Colors.md3.on_tertiary
        }
        
        Text {
            id: notifText
            
            text: notifCount
            font.pixelSize: 10
            font.weight: Font.Medium
            
            color: Colors.md3.on_tertiary
        }
    }
}
