import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications
import Quickshell.Services.Pipewire
import QtQuick

import "root:/settings" as Settings
import "Core" as Core
import "root:/widgets/notification" as Notification

ShellRoot {
    id: root

    property QtObject shellInstance: Quickshell.shell
    property QtObject notificationService

    property QtObject defaultAudioSink: Pipewire.defaultAudioSink
    property int volume: defaultAudioSink && defaultAudioSink.audio ? Math.round(defaultAudioSink.audio.volume * 100) : 0

    property alias notificationWindow: shellWindows.notificationWindow
    property QtObject notificationServer: shellWindows.notificationService
    ? shellWindows.notificationService.notificationServer
    : null

    // Notification history with auto-cleanup
    property ListModel notificationHistory: ListModel {
        Component.onDestruction: clear()
    }
    property int maxHistoryItems: 30
    property int cleanupThreshold: maxHistoryItems + 5

    // Weather state
    property string weatherLocation: Settings.Config.weatherLocation
    property var weatherData: null
    property bool weatherLoading: false
    property alias weatherService: weatherService

    Core.ShellWindows {
        id: shellWindows
        shell: root
        notificationService: notificationService
    }

    Notification.NotificationService {
        id: notificationService
        shell: root
    }

    Core.WeatherService {
        id: weatherService
        shell: root
    }

    // Consolidated timer for periodic tasks
    Timer {
        id: periodicTimer
        interval: 180000
        running: true
        repeat: true
        onTriggered: {
            // Weather update (if needed)
            if (Date.now() - weatherService.lastFetchTime >= weatherService.cacheTimeoutMs) {
                weatherService.loadWeather()
            }
            
            // Notification cleanup
            if (notificationHistory.count > maxHistoryItems) {
                const removeCount = notificationHistory.count - maxHistoryItems
                notificationHistory.remove(maxHistoryItems, removeCount)
            }
        }
    }

    Component.onCompleted: {
        weatherService.loadWeather()
    }

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    function addToNotificationHistory(notification) {
        // Trim notification content before adding
        const summary = notification.summary ? 
            (notification.summary.length > 100 ? notification.summary.substring(0, 100) + "..." : notification.summary) : ""
        const body = notification.body ? 
            (notification.body.length > 500 ? notification.body.substring(0, 500) + "..." : notification.body) : ""
            
        notificationHistory.insert(0, {
            appName: notification.appName || "",
            summary: summary,
            body: body,
            timestamp: new Date(),
            icon: notification.appIcon ? String(notification.appIcon) : ""
        })

        if (notificationHistory.count > cleanupThreshold) {
            const removeCount = notificationHistory.count - maxHistoryItems
            notificationHistory.remove(maxHistoryItems, removeCount)
        }
    }
}
