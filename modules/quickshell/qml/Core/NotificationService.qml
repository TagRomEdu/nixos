import QtQuick
import Quickshell.Services.Notifications

Item {
    id: service
    
    property var shell
    property alias notificationServer: notificationServer
    
    NotificationServer {
        id: notificationServer
        actionsSupported: true
        bodyMarkupSupported: true
        imageSupported: true
        keepOnReload: false
        persistenceSupported: true
        
        Component.onCompleted: {
            console.log("Notification server initialized")
        }
        
        onNotification: (notification) => {
            if (!notification.appName && !notification.summary && !notification.body) {
                console.warn("Skipping empty notification")
                return
            }
            console.log("[RAW NOTIFICATION] App:", notification.appName, 
                    "Summary:", notification.summary,
                    "Body:", notification.body)
            
            // Add to history
            shell.addToNotificationHistory(notification)
            
            // Show notification window
            shell.notificationWindow.visible = true
        }
    }
}