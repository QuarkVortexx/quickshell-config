pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root

    property var preferredOrder: ["DP-3", "eDP-1"]

    readonly property var primaryScreen: resolvePrimary()

    function resolvePrimary() {
        const screens = Quickshell.screens

        for (let i = 0; i < preferredOrder.length; i++) {
            const name = preferredOrder[i]

            const match = screens.find(s => s.name === name)
            if (match)
                return match
        }

        return screens[0] ?? null
    }
}