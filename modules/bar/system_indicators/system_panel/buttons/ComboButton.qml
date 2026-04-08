// modules/bar/system_indicators/system_panel/ComboButton.qml
import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes

import qs.util

RowLayout {
    id: comboButton
    property Component indicator
    property var settingsAction
    spacing: 0

    Loader {
        id: indicatorLoader
        sourceComponent: comboButton.indicator
    }

    Item {
        id: button2
        height: indicatorLoader.item ? indicatorLoader.item.height : 36
        width: button2.height / 4 * 3

        Rectangle {
            anchors.fill: parent
            color: Qt.darker(Colors.md3.primary, 1.2)
        }

        Text {
            anchors.centerIn: parent
            font.pixelSize: parent.height / 2
            color: Colors.md3.on_primary
            text: ""
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: if (comboButton.settingsAction) comboButton.settingsAction()
        }
    }
}