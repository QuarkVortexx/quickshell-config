import QtQuick

import qs.util

Item {
    id: customSlider
    width: 200
    height: 18

    property real value: 0     // 0–1 normalized
    signal sliderValueChanged(real newValue)

    Rectangle { // background track
        anchors.fill: parent
        color: Colors.md3.primary_container
    }

    Rectangle { // filled portion
        id: fill
        height: parent.height
        width: parent.width * value
        color: Colors.md3.primary
    }

    MouseArea { // handle clicks and drags
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onPressed: function(mouse) {
            value = mouse.x / parent.width
            sliderValueChanged(value)
        }
        onPositionChanged: function(mouse) {
            if (mouse.buttons & Qt.LeftButton) {
                value = Math.min(Math.max(mouse.x / parent.width, 0), 1)
                sliderValueChanged(value)
            }
        }
        onWheel: function(wheel) {
            const step = 0.05
            const delta = wheel.angleDelta.y > 0 ? step : -step
            value = Math.min(Math.max(value + delta, 0), 1)
            sliderValueChanged(value)
            wheel.accepted = true
        }
    }
}
