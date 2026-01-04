import QtQuick
import QtQuick.Controls

import Quickshell
import Quickshell.Hyprland

import "../../util"

PanelWindow {
    id: launcher
    implicitWidth: 800
    implicitHeight: 300
    color: "transparent"
    visible: StateStore.launcherOpen

    /*
     * === DATA ===
     */

    readonly property var allEntries: DesktopEntries.applications.values

    // Which desktop entries are currently expanded
    property var expandedEntries: new Set()

    // Flattened navigation list
    property var navigationItems: []

    // Currently selected row
    property int selectedIndex: 0

    // Search query
    property string query: ""

    function capitalize(str) {
        if (!str) return ""
        return str.charAt(0).toUpperCase() + str.slice(1)
    }

    function fuzzyScore(name, query) {
        let score = 0
        let lastMatch = -1
        name = name.toLowerCase()
        query = query.toLowerCase()

        for (let i = 0; i < query.length; i++) {
            const idx = name.indexOf(query[i], lastMatch + 1)
            if (idx === -1)
                return 0
            score += 10
            if (idx === lastMatch + 1)
                score += 5 // consecutive bonus
            lastMatch = idx
        }
        return score
    }


    function activateCurrent() {
        if (navigationItems.length === 0)
            return

        const item = navigationItems[selectedIndex]

        if (item.type === "entry") {
            var entry = item?.entry

            if (entry?.runInTerminal && entry?.command) {
                Quickshell.execDetached(["foot", "-e"].concat(entry.command))
            } else {
                entry?.execute()
            }
        } else {
            item.action.execute()
        }

        StateStore.launcherOpen = false;
    }

    /*
     * Navigation item format:
     * {
     *   type: "entry" | "action",
     *   entry: DesktopEntry,
     *   action?: DesktopAction
     * }
     */

    function rebuildNavigationItems() {
        let entries = []

        // 1. Filter + score
        for (const entry of allEntries) {
            const name = entry?.name ?? ""
            if (query.length === 0) {
                entries.push({
                    entry: entry,
                    score: 0
                })
            } else {
                const score = fuzzyScore(name, query)
                if (score > 0) {
                    entries.push({
                        entry: entry,
                        score: score
                    })
                }
            }
        }

        // 2. Sort
        if (query.length === 0) {
            // Alphabetical
            entries.sort((a, b) =>
                a.entry.name.localeCompare(b.entry.name)
            )
        } else {
            // Fuzzy score first, then name
            entries.sort((a, b) => {
                if (b.score !== a.score)
                    return b.score - a.score
                return a.entry.name.localeCompare(b.entry.name)
            })
        }

        // 3. Flatten into navigation items
        const items = []

        for (const obj of entries) {
            const entry = obj.entry

            items.push({
                type: "entry",
                entry: entry
            })

            if (expandedEntries.has(entry)) {
                let actions = []

                for (const action of entry.actions) {
                    actions.push({
                        type: "action",
                        entry: entry,
                        action: action
                    })
                }

                actions.sort((a, b) =>
                    a.action.name.localeCompare(b.action.name)
                )

                items.push(...actions);
            }
        }

        navigationItems = items

        // 4. Clamp selection
        if (selectedIndex >= navigationItems.length)
            selectedIndex = navigationItems.length - 1
        if (selectedIndex < 0)
            selectedIndex = 0

        // 5. Position the listView
        if (selectedIndex === 0) {
            listView.positionViewAtBeginning()
        } else {
            listView.positionViewAtIndex(selectedIndex, ListView.Contain);
        }
    }

    Component.onCompleted: rebuildNavigationItems()

    /*
     * === UI ===
     */

    Rectangle {
        anchors.fill: parent
        color: "#2A2524"
        radius: 10
        border.color: "#3A3534"
        border.width: 2
    }

    Column {
        id: launcherColumn
        anchors.fill: parent
        anchors.margins: 8
        spacing: 5

        TextField {
            id: searchField
            width: parent.width
            placeholderText: qsTr("   Search")
            font.pixelSize: 20
            color: "white"
            background: Rectangle {
                color: "#3A3534"
                radius: 5
            }
            onTextChanged: {
                query = text
                selectedIndex = 0
                expandedEntries = new Set()
                rebuildNavigationItems()
            }
            /*
            * === KEY HANDLING ===
            */

            Keys.onUpPressed: {
                if (listView.count > 0) {
                    selectedIndex = Math.max(0, selectedIndex - 1);
                    listView.positionViewAtIndex(selectedIndex, ListView.Contain);
                }
            }

            Keys.onDownPressed: {
                if (listView.count > 0) {
                    selectedIndex = Math.min(
                        navigationItems.length - 1,
                        selectedIndex + 1
                    )
                    listView.positionViewAtIndex(selectedIndex, ListView.Contain);
                }
            }

            Keys.onReturnPressed: activateCurrent()
            Keys.onEnterPressed: activateCurrent()

            Keys.onTabPressed: {
                if (navigationItems.length === 0)
                    return

                const item = navigationItems[selectedIndex]

                if (item.type !== "entry")
                    return

                if (item.entry.actions.length === 0)
                    return

                if (expandedEntries.has(item.entry)) {
                    expandedEntries.delete(item.entry)
                } else {
                    expandedEntries.add(item.entry)
                    // Move selection to first action
                    selectedIndex += 1
                }

                rebuildNavigationItems()
            }
            Keys.onEscapePressed: {
                StateStore.launcherOpen = false;
            }
        }

        ScrollView {
            id: scrollView
            width: parent.width
            height: parent.height - searchField.height - parent.spacing
            ListView {
                id: listView
                anchors.fill: parent
                model: navigationItems
                clip: true
                spacing: 0

                delegate: Item {
                    id: launcherButton
                    width: listView.width
                    height: 42

                    property bool selected: index === selectedIndex
                    property bool isAction: modelData.type === "action"

                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        hoverEnabled: true
                        onEntered: selectedIndex = index

                        // Declare "mouse" as a parameter
                        onClicked: function(mouse) {
                            if (mouse.button === Qt.LeftButton) {
                                activateCurrent()
                            } else if (mouse.button === Qt.RightButton) {
                                // Toggle expansion for the clicked entry
                                const item = navigationItems[selectedIndex]
                                if (item.type === "entry" && item.entry.actions.length > 0) {
                                    if (expandedEntries.has(item.entry)) {
                                        expandedEntries.delete(item.entry)
                                    } else {
                                        expandedEntries.add(item.entry)
                                        selectedIndex += 1
                                    }
                                    rebuildNavigationItems()
                                }
                            }
                        }
                    }

                    Rectangle {
                        anchors.fill: parent
                        color: selected ? "#313131" : "transparent"
                        radius: 5
                    }

                    Row {
                        anchors.fill: parent
                        anchors.leftMargin: 8
                        anchors.rightMargin: 8
                        spacing: 8
                        clip: true

                        Rectangle {
                            visible: expandedEntries.has(modelData.entry)
                            width: 4
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            color: isAction ? "#777" : "#666666"
                        }

                        Image {
                            visible: modelData.type === "entry"
                            id: icon
                            width: 18
                            height: 18
                            smooth: true
                            anchors.verticalCenter: parent.verticalCenter
                            source: Quickshell.iconPath(modelData?.entry?.icon ?? "application-x-generic", "foot")
                            sourceSize: Qt.size(18, 18)
                            fillMode: Image.PreserveAspectFit
                        }

                        Text {
                            text: {
                                if (modelData.type === "entry") {
                                     return capitalize(modelData.entry?.name ?? "Unknown")
                                } else {
                                    return modelData.action?.name ?? "Unknown"
                                }
                            }
                            color: "white"
                            font.pixelSize: 14
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Text {
                            text: {
                                if (modelData.type === "entry") {
                                    return modelData.entry?.comment ?? ""
                                } else {
                                    return ""
                                }
                            }
                            font.pixelSize: 12
                            color: "gray"
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Text {
                            visible: modelData.type === "entry" && modelData.entry.actions.length > 0
                            text: expandedEntries.has(modelData.entry) ? " 󰖰 " : " 󰘖 "
                            font.pixelSize: 15
                            color: "white"
                            anchors.verticalCenter: parent.verticalCenter
                        }

                    }
                }
            }
        }
    }

    Connections {
        target: StateStore
        function onLauncherOpenChanged() {
            launcherFocusGrab.active = StateStore.launcherOpen;
            if (StateStore.launcherOpen) {
                searchField.text = "";
                
                // Reset launcher state
                expandedEntries = new Set()
                selectedIndex = 0
                rebuildNavigationItems()

                Qt.callLater(() => {
                    if (searchField) {
                        searchField.forceActiveFocus();
                    }

                    if (listView) {
                        listView.positionViewAtBeginning();
                    }
                });
            }
        }
    }

    HyprlandFocusGrab {
        id: launcherFocusGrab
        windows: [launcher]
        active: false
        onCleared: () => {
            StateStore.launcherOpen = false;
        }
    }
}
