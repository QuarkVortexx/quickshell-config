// BatteryButton.qml
import QtQuick
import Quickshell
import qs.util

Item {
    id: audioSourceButton

    readonly property var source: AudioService.source
    readonly property bool isReady: AudioService.sourceReady
    readonly property bool muted: AudioService.sourceMuted

    readonly property string title: !isReady ? "Unknown" : source.description || "Unknown"
    readonly property string description: !isReady ? "No Microphone" : muted ? "Muted" : "Active"
    readonly property string icon: !isReady ? "󱦉" : muted ? "󰍭" : "󰍬"


    Rectangle {
        anchors.fill: parent
        color: !isReady ? Colors.md3.warning : muted ? Colors.md3.error : Colors.md3.primary 
    }

    Row {
        anchors.centerIn: parent
        spacing: 12

        // Icon
        Text {
            text: icon
            font.pixelSize: audioSourceButton.height / 3
            color: !isReady ? Colors.md3.on_warning : muted ? Colors.md3.on_error : Colors.md3.on_primary
            anchors.verticalCenter: parent.verticalCenter
        }

        // Title and Description
        Column {
            spacing: 2
            Text {
                text: title
                font.pixelSize: 12
                font.bold: true
                color: !isReady ? Colors.md3.on_warning : muted ? Colors.md3.on_error : Colors.md3.on_primary
                width: audioSourceButton.width - audioSourceButton.height
                clip: true
            }
            Text {
                text: description
                font.pixelSize: 10
                color: !isReady ? Colors.md3.on_warning : muted ? Colors.md3.on_error : Colors.md3.on_primary
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            AudioService.toggleSourceMute();
        }
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
    }
}