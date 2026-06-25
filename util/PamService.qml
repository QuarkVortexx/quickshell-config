pragma Singleton

import QtQuick

import Quickshell
import Quickshell.Services.Pam

Singleton {
    id: root

    property bool locked: true
    property bool authenticating: pam.active
    property string message: "Unlock"
    property string pendingPassword: ""

    PamContext {
        id: pam

        onPamMessage: {
            root.message = messageIsError && message !== "" ? message : root.message

            if (responseRequired && root.pendingPassword !== "") {
                pam.respond(root.pendingPassword)
                root.pendingPassword = ""
            }
        }

        onCompleted: function(result) {
            root.pendingPassword = ""

            if (result === PamResult.Success) {
                root.locked = false
                root.message = "Unlock"
            } else if (result === PamResult.Failed) {
                root.message = "Authentication failed"
            } else if (result === PamResult.MaxTries) {
                root.message = "Too many attempts"
            } else {
                root.message = "Authentication error"
            }
        }

        onError: function(error) {
            root.pendingPassword = ""
            root.message = PamError.toString(error)
        }
    }

    function authenticate(password) {
        if (password === "")
            return false

        if (pam.active)
            pam.abort()

        root.message = "Unlock"
        root.pendingPassword = password

        if (!pam.start()) {
            root.pendingPassword = ""
            root.message = "Unable to start authentication"
            return false
        }

        return true
    }

    function abort() {
        root.pendingPassword = ""

        if (pam.active)
            pam.abort()
    }
}