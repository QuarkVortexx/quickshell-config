//@ pragma UseQApplication

import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

import "util"
import "modules/bar"
import "modules/launcher"
import "modules/lockscreen"

Scope {
    id: root

    Bar {
        id: bar
    }

    Lockscreen {
        id: lockscreen
    }

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

    IpcHandler {
        target: "bar"

        function toggle() {
            StateStore.barOpen = !StateStore.barOpen;
        }
        function close() {
            StateStore.barOpen = false;
        }
        function open() {
            StateStore.barOpen = true;
        }
    }

    IpcHandler {
        target: "lockscreen"

        function lock() {
            PamService.locked = true
        }
    }
}
