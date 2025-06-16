import QtQuick
import Quickshell.Services.Notifications
import "root:/settings/" as Settings

Item {
    id: service
    
    property var shell
    property alias notificationServer: notificationServer
    
    property int maxHistorySize: 30
    property int cleanupThreshold: maxHistorySize + 5
    
    // More frequent cleanup of old notifications
    Timer {
        interval: 180000
        running: true
        repeat: true
        onTriggered: cleanupNotifications()
    }
    
    function cleanupNotifications() {
        if (!shell.notificationHistory) return
        
        // More aggressive cleanup
        if (shell.notificationHistory.count > maxHistorySize) {
            const removeCount = shell.notificationHistory.count - (maxHistorySize - 5)
            shell.notificationHistory.remove(maxHistorySize - 5, removeCount)
        }
        
        // Remove invalid entries and trim content
        for (let i = shell.notificationHistory.count - 1; i >= 0; i--) {
            const item = shell.notificationHistory.get(i)
            if (!item || !item.appName) {
                shell.notificationHistory.remove(i)
            } else {
                // Trim long content to save memory
                if (item.body && item.body.length > 500) {
                    item.body = item.body.substring(0, 500) + "..."
                }
                if (item.summary && item.summary.length > 100) {
                    item.summary = item.summary.substring(0, 100) + "..."
                }
            }
        }
    }
    
    NotificationServer {
        id: notificationServer
        actionsSupported: true
        bodyMarkupSupported: true
        imageSupported: true
        keepOnReload: false
        persistenceSupported: true
        
        Component.onCompleted: {
            if (Qt.application.arguments.includes("--debug")) {
                console.log("Notification server initialized")
            }
        }
        
        onNotification: (notification) => {
            // Skip empty notifications
            if (!notification.appName && !notification.summary && !notification.body) {
                if (typeof notification.dismiss === 'function') {
                    notification.dismiss()
                }
                return
            }
            
            // Skip ignored apps
            if (Settings.Config.ignoredApps.includes(notification.appName)) {
                if (typeof notification.dismiss === 'function') {
                    notification.dismiss()
                }
                return
            }
            
            if (Qt.application.arguments.includes("--debug")) {
            console.log("[NOTIFICATION] Adding to history:", notification.appName, notification.summary)
            console.log("[NOTIFICATION] Current history size:", shell.notificationHistory.count)
            }
            
            if (shell.notificationHistory) {
            shell.addToNotificationHistory(notification, maxHistorySize)
                
                if (shell.notificationHistory.count > cleanupThreshold) {
                    cleanupNotifications()
                }
            }
        }
    }
    
    Component.onDestruction: {
        if (shell.notificationHistory) {
            shell.notificationHistory.clear()
        }
    }
}
