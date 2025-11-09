import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

import "modules/bar"
import "modules/launcher"
import "util"

Scope {
    id: root

    Variants {
        model: Quickshell.screens

        Bar {
            modelData: modelData
        }
        
    }

    Launcher {
        id: launcher
        modelData: Quickshell.screens[0]
    }

    IpcHandler {
        target: "launcher"

        function toggle() {
            StateStore.launcherOpen = !StateStore.launcherOpen;
        }
        function close() {
            StateStore.launcherOpen = false;
        }
        function open() {
            StateStore.launcherOpen = true;
        }
    }
}
