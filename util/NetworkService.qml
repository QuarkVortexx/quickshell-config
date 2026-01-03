pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    /* ===== Public state ===== */

    // Wi-Fi radio
    property bool wifiEnabled: false

    // Active connection
    property var activeConnection: null
    readonly property bool wiredActive: activeConnection?.type === "ethernet"
    readonly property bool wifiActive: activeConnection?.type === "wifi"
    readonly property string connectionName: activeConnection?.name ?? ""

    // Internet connectivity
    property string internetState: "unknown"
    readonly property bool connected: internetState === "full"

    // Wi-Fi signal strength (0–100, only valid if wifiActive)
    property int wifiSignal: 0

    /* ===== Actions ===== */

    function toggleWifi(): void {
        enableWifiProc.exec([
            "nmcli",
            "radio",
            "wifi",
            wifiEnabled ? "off" : "on"
        ]);
    }

    function refresh(): void {
        if (!wifiStatusProc.running)
            wifiStatusProc.running = true;

        if (!deviceStatusProc.running)
            deviceStatusProc.running = true;

        if (!connectivityProc.running)
            connectivityProc.running = true;

        if (!wifiSignalProc.running)
            wifiSignalProc.running = true;
    }

    /* ===== Startup ===== */

    Component.onCompleted: refresh()

    /* ===== Polling ===== */

    Timer {
        interval: 3000
        running: true
        repeat: true
        onTriggered: root.refresh()
    }

    /* ===== Processes ===== */

    // --- Wi-Fi radio state ---
    Process {
        id: wifiStatusProc
        command: ["nmcli", "radio", "wifi"]
        environment: ({
            LANG: "C.UTF-8",
            LC_ALL: "C.UTF-8"
        })

        stdout: StdioCollector {
            onStreamFinished: {
                root.wifiEnabled = text.trim() === "enabled";
            }
        }
    }

    // --- Active connection (wired vs wifi) ---
    Process {
        id: deviceStatusProc
        command: ["nmcli", "-t", "-f", "TYPE,STATE,CONNECTION", "device"]
        environment: ({
            LANG: "C.UTF-8",
            LC_ALL: "C.UTF-8"
        })

        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim().split("\n");
                let chosen = null;

                for (const line of lines) {
                    const [type, state, name] = line.split(":");
                    if (state !== "connected")
                        continue;

                    // Prefer wired over wifi
                    if (type === "ethernet") {
                        chosen = { type, name };
                        break;
                    }
                    if (type === "wifi" && !chosen) {
                        chosen = { type, name };
                    }
                }

                root.activeConnection = chosen;
            }
        }
    }

    // --- Internet connectivity (real internet, not just link) ---
    Process {
        id: connectivityProc
        command: ["nmcli", "-t", "-f", "CONNECTIVITY", "general"]
        environment: ({
            LANG: "C.UTF-8",
            LC_ALL: "C.UTF-8"
        })

        stdout: StdioCollector {
            onStreamFinished: {
                root.internetState = text.trim();
            }
        }
    }

    // --- Active Wi-Fi signal strength ---
    Process {
        id: wifiSignalProc
        command: ["nmcli", "-t", "-f", "IN-USE,SIGNAL", "device", "wifi", "list"]
        environment: ({
            LANG: "C.UTF-8",
            LC_ALL: "C.UTF-8"
        })

        stdout: StdioCollector {
            onStreamFinished: {
                let strength = 0;

                for (const line of text.trim().split("\n")) {
                    const [inUse, signal] = line.split(":");
                    if (inUse === "*") {
                        strength = parseInt(signal) || 0;
                        break;
                    }
                }

                root.wifiSignal = strength;
            }
        }
    }

    // --- Toggle Wi-Fi ---
    Process {
        id: enableWifiProc
        onExited: root.refresh()
    }
}
