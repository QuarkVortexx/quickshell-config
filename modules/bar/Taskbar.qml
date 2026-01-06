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

    function getButtonWidthDistribution() {
        let widthMap = {}

        barRow.children.forEach(child => {
            child.children.forEach(button => {
                let width = Math.round(Math.min(button.implicitWidth, 150))
                widthMap[width] = (widthMap[width] || 0) + 1
            })
        })

        delete widthMap[0]
        return widthMap
    }

    function updateButtonWidth() {
        let totalButtons = 0
        let totalLength = 0

        let distribution = getButtonWidthDistribution()

        for (let key in distribution) {
            let count = distribution[key]
            totalButtons += count
            totalLength += key * count
        }

        if (totalButtons === 0) return

        // Sort keys in descending order
        let sortedKeys = Object.keys(distribution).map(Number).sort((a, b) => b - a);
        let pairs = [];

        // Create pairs
        for (let i = 0; i < sortedKeys.length; i++) {
            if (i === sortedKeys.length - 1) {
                pairs.push([sortedKeys[i], 0]); // Pair smallest key with 0
            } else {
                pairs.push([sortedKeys[i], sortedKeys[i + 1]]);
            }
        }

        let available = barRow.width - 25;

        if (totalLength <= available) {
            let extraSpace = available - totalLength;

            let largestPair = pairs[0];
            let largestKey = largestPair[0];
            let count = distribution[largestKey];

            let extraPerButton = extraSpace / count;

            let newButtonWidth = largestKey + extraPerButton;
            
            buttonWidth = Math.min(newButtonWidth, maxButtonWidth);
            return;
        }

        let overflow = totalLength - available;

        for (let pair of pairs) {
            let key = pair[0];
            let nextKey = pair[1];

            let count = distribution[key];

            let newSize = overflow / count;

            // let difference = key - newSize
            let keyDifference = key - nextKey;
            if (newSize <= keyDifference) {
                buttonWidth = key - newSize;
                return;
            }

            distribution[nextKey] += count;
            overflow -= keyDifference * count;
        }

        buttonWidth = Math.max(36, available / totalButtons);
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
            model: Object.keys(root.groupedWindows).sort()

            delegate: Row {
                required property string modelData
                property string appName: modelData
                anchors.verticalCenter: parent.verticalCenter
                spacing: 2

                Repeater {
                    model: root.groupedWindows[appName]

                    delegate: TaskButton {
                        toplevel: modelData
                        buttonMaxWidth: root.buttonWidth

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
