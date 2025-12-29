// modules/bar/TaskButton.qml
import QtQuick
import Quickshell 
import Quickshell.Wayland

Rectangle {
    id: root
    property var toplevel
    property var buttonMaxWidth

    property var totalMaxWidth: 150
    property var buttonMargin: 6
    property var buttonIconSize: 21

    width: Math.min(Math.min(buttonMaxWidth, Math.max(row.implicitWidth, buttonIconSize + 15) + buttonMargin * 2), totalMaxWidth)
    implicitWidth: width

    signal clicked(var toplevel)

    height: 25
    radius: 3

    color: mouseArea.containsMouse ? (mouseArea.pressed ? (toplevel?.activated ? "#322F2D" : "#322F2E") 
        : (toplevel?.activated ? "#3B3835" : "#373432")) 
            : (toplevel?.activated ? "#373533" : "transparent")

    border.color: mouseArea.containsMouse ? (mouseArea.pressed ? (toplevel?.activated ? "transparent" : "transparent") 
        : (toplevel?.activated ? "transparent" : "transparent")) 
            : (toplevel?.activated ? "#373533" : "transparent")

    border.width: 1

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
        anchors.margins: 6
        spacing: 6
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
            color: "white"
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
