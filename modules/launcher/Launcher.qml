import QtQuick
import QtQuick.Controls

import Quickshell
import Quickshell.Hyprland

import qs.util

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

    // ListView scroll position
    property int listViewPosition: 0

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

    function ensureIndexVisible(visibleIndex) {
        const rowHeight = 42

        const itemTop = visibleIndex * rowHeight
        const itemBottom = itemTop + rowHeight

        const viewTop = listView.contentY
        const viewBottom = listView.contentY + listView.height

        if (itemTop >= viewTop && itemBottom <= viewBottom)
            return

        if (itemTop < viewTop) {
            listView.contentY = itemTop
        } else {
            listView.contentY = itemBottom - listView.height
        }
    }

    /*
     * Navigation item format:
     * {
     *   type: "entry" | "action",
     *   entry: DesktopEntry,
     *   action?: DesktopAction
     * }
     */

    function rebuildNavigationItems(visibleIndex) {
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
        if (listView) {
            listView.contentY = listViewPosition
            ensureIndexVisible(visibleIndex)
        }
    }

    Component.onCompleted: rebuildNavigationItems(0)

    /*
     * === UI ===
     */

    Rectangle {
        anchors.fill: parent
        color: Colors.md3.surface
        radius: 0
        border.color: Qt.lighter(Colors.md3.surface, 2.0)
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
            color: Colors.md3.on_surface_variant
            background: Rectangle {
                color: Colors.md3.surface_variant
                radius: 0
            }
            onTextChanged: {
                query = text
                selectedIndex = 0
                expandedEntries = new Set()
                rebuildNavigationItems(0)
            }
            /*
            * === KEY HANDLING ===
            */

            Keys.onUpPressed: {
                if (listView.count > 0) {
                    selectedIndex = Math.max(0, selectedIndex - 1);
                    ensureIndexVisible(selectedIndex);
                }
            }

            Keys.onDownPressed: {
                if (listView.count > 0) {
                    selectedIndex = Math.min(
                        navigationItems.length - 1,
                        selectedIndex + 1
                    )
                    ensureIndexVisible(selectedIndex);
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

                listViewPosition = listView.contentY

                if (expandedEntries.has(item.entry)) {
                    expandedEntries.delete(item.entry)
                } else {
                    expandedEntries.add(item.entry)
                    // Move selection to first action
                    selectedIndex += 1
                }

                rebuildNavigationItems(selectedIndex)
            }
            Keys.onEscapePressed: {
                StateStore.launcherOpen = false;
            }
        }


        ListView {
            id: listView
            width: parent.width
            height: parent.height - searchField.height - parent.spacing
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
                                listViewPosition = listView.contentY

                                if (expandedEntries.has(item.entry)) {
                                    expandedEntries.delete(item.entry)
                                } else {
                                    expandedEntries.add(item.entry)
                                    selectedIndex += 1
                                }
                                rebuildNavigationItems(selectedIndex)
                            }
                        }
                    }
                }

                Rectangle {
                    anchors.fill: parent
                    color: selected ? Colors.md3.primary : "transparent"
                    radius: 0
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
                        color: selected ? (isAction ? Qt.darker(Colors.md3.on_primary, 1.5) : Qt.lighter(Colors.md3.on_primary, 1.5)) : (isAction ? Qt.darker(Colors.md3.on_surface, 1.5) : Qt.lighter(Colors.md3.on_surface, 1.5))
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
                        color: selected ? Colors.md3.on_primary : Colors.md3.on_surface
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
                        color: selected ? Qt.lighter(Colors.md3.on_primary, 1.5) : Qt.darker(Colors.md3.on_surface, 1.5)
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        visible: modelData.type === "entry" && modelData.entry.actions.length > 0
                        text: expandedEntries.has(modelData.entry) ? " 󰖰 " : " 󰘖 "
                        font.pixelSize: 15
                        color: selected ? Colors.md3.on_primary : Colors.md3.on_surface
                        anchors.verticalCenter: parent.verticalCenter
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
                rebuildNavigationItems(0)

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
