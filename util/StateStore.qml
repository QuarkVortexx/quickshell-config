pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell

Singleton {
    id: root
    property bool barOpen: true
    property bool launcherOpen: false
    property bool trayOpen: false
    property bool systemPanelOpen: false
    property bool calendarOpen: false
}
