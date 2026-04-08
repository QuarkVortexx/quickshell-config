import Quickshell

import QtQuick
import QtQuick.Layouts

import "../buttons"
import "../sliders"
import "../../indicators"
import "../"

import qs.util

Item {
    id: quickSettingsPanel
    
    implicitHeight: quickSettingsColumn.implicitHeight + quickSettingsColumn.anchors.margins * 2
    implicitWidth: quickSettingsColumn.implicitWidth + quickSettingsColumn.anchors.margins * 2

    Rectangle {
        anchors.fill: parent
        color: Colors.md3.surface
        border.color: Qt.lighter(Colors.md3.surface, 2.0)
        border.width: 2
    }

    function execAndClose(cmdArray) {
        Quickshell.execDetached(cmdArray);
        StateStore.systemPanelOpen = false;
    }

    ColumnLayout {
        id: quickSettingsColumn
        anchors.fill: parent
        spacing: 15
        anchors.margins: 10

        ComboButton {
            indicator: BatteryButton { 
                height: 62
                width: 124  * 2 + 2 + 62 / 4 * 3
            }
            settingsAction: function() { execAndClose(["foot", "-e", "btop"]); }
        }

        RowLayout {
            spacing: 2

            ComboButton {
                indicator: WifiButton { 
                    height: 62
                    width: 124
                }
                settingsAction: function() { execAndClose(["foot", "-e", "wlctl"]); }
            }

            ComboButton {
                indicator: BluetoothButton { 
                    height: 62
                    width: 124
                }
                settingsAction: function() { execAndClose(["foot", "-e", "bluetui"]); }
            }
        }

        ColumnLayout {
            id: audioControls
            spacing: 5

            RowLayout {
                spacing: 2

                ComboButton {
                    indicator: AudioSinkButton { 
                        height: 62
                        width: 124
                    }
                    settingsAction: function() { execAndClose(["foot", "-e", "wiremix", "-v", "output"]); }
                }

                ComboButton {
                    indicator: AudioSourceButton { 
                        height: 62
                        width: 124
                    }
                    settingsAction: function() { execAndClose(["foot", "-e", "wiremix", "-v", "input"]); }
                }
            }

            VolumeSlider {
                height: 42
                width: 124  * 2 + 2 + 62 / 4 * 3 * 2
            }
        }

    }
}