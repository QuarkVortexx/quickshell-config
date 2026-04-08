import QtQuick
import qs.util

Item {
    id: volumeSlider

    readonly property bool sinkReady: AudioService.sinkReady
    readonly property bool muted: AudioService.muted
    readonly property int percentage: AudioService.percentage;
    property real value: AudioService.volume

    // Icon logic
    readonly property string icon: {
        if (!sinkReady) return "?"
        if (muted) return ""
        if (percentage >= 60) return ""
        if (percentage >= 30) return ""
        return ""
    }

    readonly property color backgroundColor: !sinkReady ? Qt.darker(Colors.md3.warning, 1.5) : muted ? Qt.darker(Colors.md3.error, 1.5) : Qt.darker(Colors.md3.primary, 1.5)
    readonly property color fillColor: !sinkReady ? Colors.md3.warning : muted ? Colors.md3.error : Colors.md3.primary
    readonly property color textColor: !sinkReady ? Colors.md3.on_warning : muted ? Colors.md3.on_error : Colors.md3.on_primary

    Rectangle { // background track
        anchors.fill: parent
        color: backgroundColor
    }

    Rectangle { // filled portion
        id: fill
        height: parent.height
        width: parent.width * value
        color: fillColor
    }

    Row {
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 10
        spacing: 3

        // Icon text
        Text {
            text: icon
            color: textColor
            font.pixelSize: 14
            font.bold: true
            anchors.verticalCenter: parent.verticalCenter
        }

        // Percentage text
        Text {
            text: !sinkReady ? "-" : percentage + "%"
            color: textColor
            font.pixelSize: 12
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    MouseArea { // handle clicks and drags
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onPressed: function(mouse) {
            if (mouse.buttons & Qt.LeftButton && sinkReady && !muted) {
                let newValue = Math.min(Math.max(mouse.x / parent.width, 0), 1)
                AudioService.setVolume(newValue)
            }
            if (mouse.buttons & Qt.RightButton && sinkReady) {
                AudioService.toggleMute()
            }
        }
        onPositionChanged: function(mouse) {
            if (mouse.buttons & Qt.LeftButton && sinkReady && !muted) {
                let newValue = Math.min(Math.max(mouse.x / parent.width, 0), 1)
                AudioService.setVolume(newValue)
            }
        }
        onWheel: function(wheel) {
            if (!sinkReady || muted) return
            const step = 0.05
            const delta = wheel.angleDelta.y > 0 ? step : -step
            let newValue = Math.min(Math.max(value + delta, 0), 1)
            AudioService.setVolume(newValue)
            wheel.accepted = true
        }
    }
}