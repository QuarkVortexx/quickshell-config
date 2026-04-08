// modules/bar/TaskButton.qml
import QtQuick
import Quickshell 
import Quickshell.Wayland
import qs.util

Rectangle {
    id: root
    property var toplevel
    property var buttonMaxWidth

    implicitHeight: parent.height

    property var totalMaxWidth: implicitHeight * 5
    property var buttonMargin: implicitHeight / 5
    property var buttonIconSize: implicitHeight - buttonMargin * 1.5

    width: Math.min(Math.min(buttonMaxWidth, Math.max(row.implicitWidth, buttonIconSize + implicitHeight / 2) + buttonMargin * 2), totalMaxWidth)
    implicitWidth: width

    signal clicked(var toplevel)

    color: mouseArea.containsMouse ? (mouseArea.pressed ? (toplevel?.activated ? Qt.lighter(Colors.md3.primary, 1.10) : Qt.lighter(Colors.md3.secondary, 1.10)) 
        : (toplevel?.activated ? Qt.darker(Colors.md3.primary, 1.10) : Qt.darker(Colors.md3.secondary, 1.10))) 
            : (toplevel?.activated ? Colors.md3.primary : "transparent")

    property var textColor: mouseArea.containsMouse ? (mouseArea.pressed ? (toplevel?.activated ? Qt.lighter(Colors.md3.on_primary, 1.10) : Qt.lighter(Colors.md3.on_secondary, 1.10)) 
        : (toplevel?.activated ? Qt.darker(Colors.md3.on_primary, 1.10) : Qt.darker(Colors.md3.on_secondary, 1.10))) 
            : (toplevel?.activated ? Colors.md3.on_primary : Colors.md3.on_surface)

    property var entry: DesktopEntries.heuristicLookup(toplevel?.appId)
    property var iconPath: Quickshell.iconPath(entry?.icon ?? "application-x-generic") // default icon not always found?

    Connections {
        target: DesktopEntries
        function onApplicationsChanged() {
            entry = DesktopEntries.heuristicLookup(toplevel?.appId)
        }
    }

    Row {
        id: row
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: buttonMargin
        spacing: buttonMargin
        clip: true

        Image {
            id: icon
            width: buttonIconSize
            height: buttonIconSize
            smooth: true
            anchors.verticalCenter: parent.verticalCenter
            source: iconPath
            sourceSize: Qt.size(buttonIconSize, buttonIconSize)
            fillMode: Image.PreserveAspectFit
        }

        Text {
            id: label
            text: `${toplevel.title}`
            color: textColor
            font.pixelSize: 10
            elide: Text.ElideRight
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        hoverEnabled: true

        onClicked: root.clicked(toplevel)
    }
}
