//@ pragma UseQApplication

import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

import "util"
import "modules/bar"
import "modules/launcher"

Scope {
    id: root

    Bar { }

    Launcher {
        id: launcher
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
