import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications
import Quickshell.Services.Pipewire
import QtQuick

import "root:/Data" as Data
import "root:/Core" as Core
import "root:/Services" as Services
import "root:/Layout" as Layout
import "root:/Widgets/Lockscreen"

ShellRoot {
    id: root

    property var shellInstance: Quickshell.shell
    property var notificationService

    property var defaultAudioSink: Pipewire.defaultAudioSink
    property int volume: defaultAudioSink && defaultAudioSink.audio ? Math.round(defaultAudioSink.audio.volume * 100) : 0

    property alias notificationWindow: shellWindows.notificationWindow
    property var notificationServer: shellWindows.notificationService
    ? shellWindows.notificationService.notificationServer
    : null

    // Notification history with auto-cleanup
    property ListModel notificationHistory: ListModel {
        Component.onDestruction: clear()
    }
    property int maxHistoryItems: 25
    property int cleanupThreshold: maxHistoryItems + 5

    property string weatherLocation: Data.Settings.weatherLocation
    property var weatherData: null
    property bool weatherLoading: false
    property alias weatherService: weatherService

    // Expose lockscreen for ProcessManager access
    property alias lockscreen: lockscreen

    Core.ShellWindows {
        id: shellWindows
        shell: root
        notificationService: notificationService
    }

    Layout.Desktop {
        id: desktop
        shell: root
    }

    Services.NotificationService {
        id: notificationService
        shell: root
    }

    Services.WeatherService {
        id: weatherService
        shell: root
    }

    // Custom lockscreen component
    Lockscreen {
        id: lockscreen
        shell: root
    }

    Component.onCompleted: {
        weatherService.loadWeather()
    }

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    function addToNotificationHistory(notification) {
        notificationHistory.insert(0, {
            appName: notification.appName,
            summary: notification.summary,
            body: notification.body,
            timestamp: new Date(),
            icon: notification.appIcon ? String(notification.appIcon) : ""
        })

        // Cleanup excess notifications immediately
        if (notificationHistory.count > cleanupThreshold) {
            const removeCount = notificationHistory.count - maxHistoryItems
            notificationHistory.remove(maxHistoryItems, removeCount)
        }
    }

    // Cleanup timer (30 min)
    Timer {
        interval: 1800000
        running: true
        repeat: true
        onTriggered: {
            if (notificationHistory.count > maxHistoryItems) {
                const removeCount = notificationHistory.count - maxHistoryItems
                notificationHistory.remove(maxHistoryItems, removeCount)
            }
            
            gc()
        }
    }
    
    // Memory cleanup timer (10 min)
    Timer {
        interval: 600000
        running: true
        repeat: true
        onTriggered: {
            // More aggressive cleanup threshold
            if (notificationHistory.count > maxHistoryItems * 0.8) {
                const removeCount = notificationHistory.count - Math.floor(maxHistoryItems * 0.7)
                notificationHistory.remove(Math.floor(maxHistoryItems * 0.7), removeCount)
            }
            
            // Double garbage collection for better memory release
            gc()
            Qt.callLater(gc)
        }
    }
}
