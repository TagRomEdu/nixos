import QtQuick
import Quickshell.Services.Notifications
import "root:/Data/" as Data

Item {
    id: service
    
    property var shell
    property alias notificationServer: notificationServer
    
    property int maxHistorySize: 50
    
    NotificationServer {
        id: notificationServer
        actionsSupported: true
        bodyMarkupSupported: true
        imageSupported: true
        keepOnReload: false
        persistenceSupported: true
        
        Component.onCompleted: {
            // Notify when the notification server is ready (debug only)
            if (Qt.application.arguments.includes("--debug")) {
                console.log("Notification server initialized")
            }
        }
        
        onNotification: (notification) => {
            // Filter out notifications with no meaningful content
            if (!notification.appName && !notification.summary && !notification.body) {
                if (typeof notification.dismiss === 'function') {
                    notification.dismiss()
                }
                return
            }
            
            // Ignore notifications from apps in ignoredApps list
            if (Data.Settings.ignoredApps.includes(notification.appName)) {
                if (typeof notification.dismiss === 'function') {
                    notification.dismiss()
                }
                return
            }
            
            // Log notification details in debug mode
            if (Qt.application.arguments.includes("--debug")) {
                console.log("[NOTIFICATION]", notification.appName, notification.summary)
            }
            
            // Add to shell notification history, capped at maxHistorySize
            shell.addToNotificationHistory(notification, maxHistorySize)
            
            // Show notification window if hidden
            if (!shell.notificationWindow.visible) {
                shell.notificationWindow.visible = true
            }
        }
    }
}
