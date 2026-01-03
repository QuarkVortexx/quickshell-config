import QtQuick
import QtQuick.Layouts

import qs.util

Item {
    id: root
    implicitWidth: clockText.width
    implicitHeight: clockText.height

    Text {
        id: clockText
        text: TimeService.format("hh:mm:ss")
        color: "white"
        font.pixelSize: 14
    }
}