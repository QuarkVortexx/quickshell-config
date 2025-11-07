// modules/bar/bar.qml
import Quickshell
import Quickshell.Wayland
import QtQuick

Item {
    id: root

    property var groupedWindows: ({})

    // max width for a single button
    property int maxButtonWidth: 150

    // Computed width for all buttons
    property real buttonWidth: maxButtonWidth

    function updateGrouping() {
        let map = {}
        for (let top of ToplevelManager.toplevels.values) {
            let appClass = top.appId
            if (!appClass)
                continue
            if (!map[appClass])
                map[appClass] = []
            map[appClass].push(top)
        }
        groupedWindows = map
        updateButtonWidth()
    }

    function updateButtonWidth() {
        let totalButtons = 0
        for (let key in groupedWindows) totalButtons += groupedWindows[key].length

        if (totalButtons === 0) return

        let available = barRow.width - 25
        let needed = totalButtons * maxButtonWidth
        buttonWidth = (needed <= available) ? maxButtonWidth : (available / totalButtons)
    }

    Connections {
        target: ToplevelManager.toplevels
        function onValuesChanged() { updateGrouping() }
    }

    Component.onCompleted: updateGrouping()

    Row {
        id: barRow
        anchors.fill: parent
        spacing: 2

        Repeater {
            model: Object.keys(root.groupedWindows)

            delegate: Row {
                required property string modelData
                property string appName: modelData
                anchors.verticalCenter: parent.verticalCenter
                spacing: 2

                Repeater {
                    model: root.groupedWindows[appName]

                    delegate: TaskButton {
                        toplevel: modelData
                        width: root.buttonWidth

                        onClicked: (toplevel) => {
                            if (toplevel.activate)
                                toplevel.activate()
                            else if (toplevel.requestActivate)
                                toplevel.requestActivate()
                        }
                    }
                }
            }
        }

        // Listen for width changes of the bar
        onWidthChanged: updateButtonWidth()
    }
}
