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

    Row {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 4
        spacing: 8

        Image {
            id: icon
            width: 24
            height: 24
            fillMode: Image.PreserveAspectFit
            smooth: true
            anchors.verticalCenter: parent.verticalCenter
            source: "image://icon/" + toplevel.appId
        }

        Text {
            id: label
            text: `${toplevel.appId} - ${toplevel.title}`
            color: "white"
            font.pixelSize: 10
            elide: Text.ElideRight
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        hoverEnabled: true

        onClicked: root.clicked(toplevel)
    }
}
