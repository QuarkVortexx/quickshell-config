import Quickshell
import Quickshell.Wayland
import QtQuick

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
        function onValuesChanged() {
            updateGrouping()
        }
    }

    Component.onCompleted: updateGrouping()

    // --- Display ---
    Row {
        spacing: 10

        Repeater {
            model: Object.keys(root.groupedWindows)
            delegate: Row {
                required property string modelData
                property string appName: modelData

                Text {
                    text: `App: ${appName}`
                    font.bold: true
                    color: "cyan"
                }

                Repeater {
                    model: root.groupedWindows[appName]
                    delegate: Text {
                        required property var modelData
                        text: `  • ${modelData.title}`
                        color: "lightgray"
                    }
                }
            }
        }
    }
}
