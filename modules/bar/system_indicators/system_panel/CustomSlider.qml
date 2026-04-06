import QtQuick

import qs.util

Item {
    id: customSlider
    width: 200
    height: 18

    property real value: 0     // 0–1 normalized
    signal sliderValueChanged(real newValue)

    property string icon: ""; // optional icon name to display on the left side of the slider

    Rectangle { // background track
        anchors.fill: parent
        color: Qt.darker(Colors.md3.primary, 1.5)
    }

    Rectangle { // filled portion
        id: fill
        height: parent.height
        width: parent.width * value
        color: Colors.md3.primary
    }

    Text {
        text: icon
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 10
        color: Colors.md3.on_primary
        font.pixelSize: 14
        font.bold: true
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
