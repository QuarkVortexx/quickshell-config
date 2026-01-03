pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    /* ===== Public state ===== */
    property bool powered: false           // Bluetooth adapter power
    property bool connected: false         // At least one device connected
    property int connectedCount: 0         // Number of connected devices

    /* ===== Actions ===== */
    function togglePower() {
        const cmd = powered ? "power off" : "power on"
        toggleProc.command = ["bluetoothctl", cmd]
        toggleProc.running = true
    }

    function refresh(): void {
        if (!statusProc.running)
            statusProc.running = true;

        if (!connectedProc.running)
            connectedProc.running = true;
    }

    /* ===== Polling ===== */
    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.refresh()
    }

    /* ===== Processes ===== */

    // --- Check adapter status (powered or not) ---
    Process {
        id: statusProc
        command: ["bluetoothctl", "show"]
        stdout: StdioCollector {
            onStreamFinished: {
                const isPowered = text.includes("Powered: yes")
                if (root.powered !== isPowered) {
                    root.powered = isPowered
                }
            }
        }
    }

    // --- Check connected devices ---
    Process {
        id: connectedProc
        command: ["bluetoothctl", "devices", "Connected"]
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim().split("\n").filter(l => l.length > 0)
                root.connectedCount = lines.length
                root.connected = lines.length > 0
            }
        }
    }

    // --- Toggle Bluetooth power ---
    Process {
        id: toggleProc
        onExited: statusProc.running = true
    }

    /* ===== Watch for power changes ===== */
    onPoweredChanged: {
        if (powered) {
            connectedProc.running = true
        } else {
            connected = false
            connectedCount = 0
        }
    }
}
