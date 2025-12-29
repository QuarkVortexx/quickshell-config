import QtQuick
import Quickshell 

import "../../util"

Rectangle {
    property var entry
    property var highlighted
    property var iconPath: Quickshell.iconPath(entry?.icon ?? "application-x-generic", "kitty") // default icon not always found?

    height: 42
    color: highlighted ? "#313131" : "transparent"
    radius: 5

    signal hovered()
    signal clicked()

    onClicked: {
        if (entry?.runInTerminal && entry?.command) {
            Quickshell.execDetached(["foot", "-e"].concat(entry.command))
        } else {
            entry?.execute()
        }
        StateStore.launcherOpen = false
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: parent.clicked()
        onEntered: parent.hovered()
    }

    Row {
        anchors.fill: parent
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        anchors.topMargin: 2
        anchors.bottomMargin: 2
        spacing: 8
        clip: true

        Image {
            id: icon
            width: 18
            height: 18
            smooth: true
            anchors.verticalCenter: parent.verticalCenter
            source: iconPath
            sourceSize: Qt.size(18, 18)
            fillMode: Image.PreserveAspectFit
        }

        Text {
            text: entry?.name ?? "Unknown"
            color: "white"
            font.pixelSize: 14
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: entry?.comment ?? ""
            font.pixelSize: 12
            color: "gray"
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}