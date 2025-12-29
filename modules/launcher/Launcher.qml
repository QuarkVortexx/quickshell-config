import Quickshell
import Quickshell.Hyprland

import QtQuick
import QtQuick.Controls

import "../../util"

PanelWindow {
    id: launcherWindow

    implicitWidth: 800
    implicitHeight: 300
    visible: StateStore.launcherOpen

    color: "transparent"

    property string query: ""
    property int currentIndex: 0
    readonly property var allEntries: DesktopEntries.applications.values

    function fuzzyScore(name, query) {
        let i = 0, j = 0;
        name = name.toLowerCase();
        query = query.toLowerCase();
        while (i < name.length && j < query.length) {
            if (name[i] === query[j]) {
                j++;
            }
            i++;
        }
        return j === query.length ? j : 0;
    }

    ScriptModel {
        id: filteredModel
        values: {
            const q = query.trim().toLowerCase()

            const sortedEntries = allEntries.sort((a, b) => {
                return (a.name || "").toLowerCase().localeCompare((b.name || "").toLowerCase())
            });

            if (q === "") {
                return sortedEntries
            } else {
                let list = allEntries.map(d => {
                    let sc = d.name ? fuzzyScore(d.name, q) : 0;
                    return { entry: d, score: sc }
                }).filter(obj => obj.score > 0);

                list.sort((a,b) => b.score - a.score);
                return list.map(obj => obj.entry);
            }
        }
    }

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
            placeholderText: qsTr("Search applications...")
            font.pixelSize: 20
            color: "white"
            background: Rectangle {
                color: "#3A3534"
                radius: 5
            }
            onTextChanged: {
                launcherWindow.query = text;
                launcherWindow.currentIndex = 0;
            }
            Keys.onDownPressed: {
                if (listView.count > 0) {
                    currentIndex = Math.min(currentIndex + 1, listView.count - 1);
                    listView.positionViewAtIndex(currentIndex, ListView.Contain);
                }
            }
            Keys.onUpPressed: {
                if (listView.count > 0) {
                    currentIndex = Math.max(currentIndex - 1, 0);
                    listView.positionViewAtIndex(currentIndex, ListView.Contain);
                }
            }
            Keys.onReturnPressed: {
                if (listView.count > 0) {
                    listView.itemAtIndex(currentIndex).clicked();
                }
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
                model: filteredModel.values
                spacing: 4
                clip: true

                delegate: LauncherButton {
                    entry: modelData
                    highlighted: index === launcherWindow.currentIndex
                    width: launcher.width - 16
                    onHovered: launcherWindow.currentIndex = index
                }

                Component.onCompleted: {
                    positionViewAtBeginning(ListView.Contain);
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
                currentIndex = 0;

                Qt.callLater(() => {
                    if (searchField) {
                        searchField.forceActiveFocus();
                    }

                    if (listView) {
                        listView.positionViewAtBeginning(ListView.Contain);
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
