import QtQuick
import Quickshell.Services.Notifications
import "root:/Data/" as Data

Item {
    id: service
    
    property var shell
    property alias notificationServer: notificationServer
    
    property int maxHistorySize: 50
    property int cleanupThreshold: maxHistorySize + 10
    
    // Periodic cleanup of old notifications
    Timer {
        interval: 300000
        running: true
        repeat: true
        onTriggered: cleanupNotifications()
    }
    
    function cleanupNotifications() {
        if (shell.notificationHistory && shell.notificationHistory.count > cleanupThreshold) {
            const removeCount = shell.notificationHistory.count - maxHistorySize
            shell.notificationHistory.remove(maxHistorySize, removeCount)
        }
        
        // Remove invalid entries
        if (shell.notificationHistory) {
            for (let i = shell.notificationHistory.count - 1; i >= 0; i--) {
                const item = shell.notificationHistory.get(i)
                if (!item || !item.appName) {
                    shell.notificationHistory.remove(i)
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
            if (Data.Settings.ignoredApps.includes(notification.appName)) {
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
            
            if (!shell.notificationWindow.visible) {
                shell.notificationWindow.visible = true
            }
        }
    }
    
    Component.onDestruction: {
        if (shell.notificationHistory) {
            shell.notificationHistory.clear()
        }
    }
}
