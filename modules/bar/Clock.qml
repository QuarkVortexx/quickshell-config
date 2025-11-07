import QtQuick
import QtQuick.Layouts
import "../../processes/time"

Item {
    id: root
    implicitWidth: clockText.width
    implicitHeight: clockText.height

    Text {
        id: clockText
        text: Time.time
        color: "white"
        font.pixelSize: 14
    }
}