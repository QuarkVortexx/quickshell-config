// modules/bar/VolumeIndicator.qml
import QtQuick
import QtQuick.Shapes
import QtQuick.Layouts
import Quickshell

import qs.util

Item {
    id: volumeIndicator
    implicitWidth: volumeRow.implicitWidth + volumeRow.anchors.margins * 2
    height: 24

    readonly property bool isReady: AudioService.sinkReady
    readonly property bool isMuted: AudioService.muted
    readonly property int percentage: AudioService.percentage;

    MouseArea {
        anchors.fill: parent
        onWheel: wheel => {
            if (wheel.angleDelta.y > 0) {
                AudioService.increaseVolume()
            } else {
                AudioService.decreaseVolume()
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: !AudioService.sinkReady ? Colors.md3.warning : AudioService.muted ? Colors.md3.error : "transparent"
    }

    RowLayout {
        id: volumeRow
        anchors.centerIn: parent
        anchors.margins: 5
        spacing: 3
        
        Text {
            id: volumeIcon
            
            text: {
                if (!isReady) return "?"
                if (isMuted) return ""
                if (percentage >= 60) return ""
                if (percentage >= 30) return ""
                return ""
            }
            
            font.pixelSize: 15      
            color: !AudioService.sinkReady ? Colors.md3.on_warning : AudioService.muted ? Colors.md3.on_error : Colors.md3.on_surface
        }
        
        Text {
            id: volumeText
            
            text: percentage
            font.pixelSize: 10
            font.weight: Font.Medium
            
            color: !AudioService.sinkReady ? Colors.md3.on_warning : AudioService.muted ? Colors.md3.on_error : Colors.md3.on_surface
        }
    }
}
