pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Singleton {
    // Reference to the notification server
    NotificationServer { id: notifServer }

    // Signal for when the notifications list changes
    signal notificationsUpdated()

    // Connect to incoming notifications
    Connections {
        target: notifServer

        function onNotification(n) {
            n.tracked = true

            // Emit change signal
            notificationsUpdated()
        }
    }

    // Function to clear all stored notifications
    function clear() {
        for (let i = notifServer.trackedNotifications.values.length - 1; i >= 0; i--) {
            notifServer.trackedNotifications.values[i].dismiss()
        }

        notificationsUpdated()
    }

    // Function to get the count
    function count() {
        return notifServer.trackedNotifications.values.length
    }

    // Function to get all notifications
    function all() {
        return notifServer.trackedNotifications
    }
}
