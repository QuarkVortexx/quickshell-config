// modules/bar/TaskButton.qml
import QtQuick

Rectangle {
    id: root
    property var toplevel

    signal clicked(var toplevel)

    height: 42
    radius: 3

    color: mouseArea.containsMouse ? (mouseArea.pressed ? (toplevel?.activated ? "#322F2D" : "#322F2E") 
        : (toplevel?.activated ? "#3B3835" : "#373432")) 
            : (toplevel?.activated ? "#373533" : "transparent")

    border.color: mouseArea.containsMouse ? (mouseArea.pressed ? (toplevel?.activated ? "transparent" : "transparent") 
        : (toplevel?.activated ? "transparent" : "transparent")) 
            : (toplevel?.activated ? "#373533" : "transparent")

    border.width: 1
    clip: true   // ensures text does not draw outside the rectangle

    Text {
        id: label
        anchors.centerIn: parent
        text: `${toplevel.appId} - ${toplevel.title}`
        color: "white"
        font.pixelSize: 10
        horizontalAlignment: Text.AlignHLeft
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight   // clips text with "…" if too long
        anchors.leftMargin: 4
        anchors.rightMargin: 4
        anchors.fill: parent
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        hoverEnabled: true

        onClicked: root.clicked(toplevel)
    }
}
