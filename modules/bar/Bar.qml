// modules/bar/bar.qml
import Quickshell
import Quickshell.Wayland
import QtQuick
import "./TaskButton.qml"

Item {
    id: root

    property var groupedWindows: ({})

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
    }

    Connections {
        target: ToplevelManager.toplevels
        function onValuesChanged() { updateGrouping() }
    }

    Component.onCompleted: updateGrouping()

    Row {
        spacing: 8

        Repeater {
            model: Object.keys(root.groupedWindows)

            delegate: Row {
                required property string modelData
                property string appName: modelData
                spacing: 4

                Repeater {
                    model: root.groupedWindows[appName]

                    delegate: TaskButton {
                        appName: appName
                        title: modelData.title
                        toplevel: modelData

                        onClicked: (toplevel) => {
                            console.log("Clicked:", appName, "-", toplevel.title)
                            if (toplevel.activate)
                                toplevel.activate()
                            else if (toplevel.requestActivate)
                                toplevel.requestActivate()
                            else
                                console.warn("No activation available for:", appName)
                        }
                    }
                }
            }
        }
    }
}
