//@ pragma UseQApplication

import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

import "modules/bar"
import "modules/launcher"
import "util"

Scope {
    id: root

    Bar { }

    Launcher {
        id: launcher
    }

    TrayPanel {
        id: trayPanel
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
