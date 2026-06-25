import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland

import qs.util

WlSessionLock {
    id: lock
    locked: PamService.locked

    WlSessionLockSurface {
        id: surface
        property bool isPrimary: screen === ScreenManager.primaryScreen

        Rectangle {
            anchors.fill: parent
            color: Colors.md3.surface

            Rectangle {
                width: 320
                height: 48
                anchors.centerIn: parent

                color: Colors.md3.surface_container
                border.color: Colors.md3.outline
                border.width: 1
                radius: 0

                visible: surface.isPrimary

                TextField {
                    id: passwordField
                    anchors.fill: parent
                    anchors.margins: 6

                    placeholderText: PamService.authenticating ? "Authenticating" : PamService.message
                    echoMode: TextInput.Password
                    focus: true

                    color: Colors.md3.on_surface
                    placeholderTextColor: Colors.md3.on_surface_variant

                    background: Rectangle {
                        color: "transparent"
                        radius: 0
                    }

                    enabled: !PamService.authenticating

                    function submit() {
                        if (text.length === 0)
                            return

                        if (PamService.authenticate(text))
                            text = ""
                    }

                    onAccepted: submit()
                    Keys.onEnterPressed: submit()
                    Keys.onReturnPressed: submit()
                }
            }
        }
    }
}