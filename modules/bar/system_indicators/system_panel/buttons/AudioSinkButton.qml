// BatteryButton.qml
import QtQuick
import Quickshell
import qs.util

Item {
    id: audioSinkButton

    readonly property var sink: AudioService.sink
    readonly property bool isReady: AudioService.sinkReady
    readonly property bool muted: AudioService.muted
    readonly property int percentage: AudioService.percentage

    readonly property string title: !isReady ? "Unknown" : sink.description || "Unknown"
    readonly property string description: !isReady ? "No Audio Sink" : muted ? "Muted" : "Active"
    readonly property string icon: {
        if (!isReady) return "?"
        if (muted) return ""
        if (percentage >= 60) return ""
        if (percentage >= 30) return ""
        return ""
    }


    Rectangle {
        anchors.fill: parent
        color: !isReady ? Colors.md3.warning : muted ? Colors.md3.error : Colors.md3.primary 
    }

    Row {
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 12

        // Icon
        Text {
            text: icon
            font.pixelSize: audioSinkButton.height / 3
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
                width: audioSinkButton.width - audioSinkButton.height
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
            AudioService.toggleMute();
        }
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
    }
}