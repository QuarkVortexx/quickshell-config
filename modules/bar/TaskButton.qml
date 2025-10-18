// modules/bar/TaskButton.qml
import QtQuick

Rectangle {
    id: root
    property string appName: ""
    property string title: ""
    property var toplevel    // the actual window/toplevel object

    signal clicked(var toplevel)

    width: Math.max(label.implicitWidth + 20, 80)
    height: Math.min(label.implicitHeight + 20, 24)
    radius: 6
    color: toplevel?.activated ? "#4a6cf0" : "#2a2a2a"

    border.color: toplevel?.activated ? "#6f8fff" : "#444"
    border.width: 1

    Text {
        id: label
        anchors.centerIn: parent
        text: `${appName} - ${title}`
        color: "white"
        font.pixelSize: 12
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onClicked: root.clicked(toplevel)

        onPressed: root.color = "#5b7eff"
        onReleased: root.color = toplevel?.activated ? "#4a6cf0" : "#2a2a2a"
        onEntered: if (!toplevel?.activated) root.color = "#3a3a3a"
        onExited:  if (!toplevel?.activated) root.color = "#2a2a2a"
    }
}
