import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications
import Quickshell.Services.Pipewire
import QtQuick

import "root:/Data" as Data
import "Core" as Core

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
    property int maxHistoryItems: 50
    property int cleanupThreshold: maxHistoryItems + 10

    // Weather state
    property string weatherLocation: Data.Settings.weatherLocation
    property var weatherData: null
    property bool weatherLoading: false
    property alias weatherService: weatherService

    Core.ShellWindows {
        id: shellWindows
        shell: root
        notificationService: notificationService
    }

    Core.NotificationService {
        id: notificationService
        shell: root
    }

    Core.WeatherService {
        id: weatherService
        shell: root
    }

    Timer {
        interval: 600000
        running: true
        repeat: true
        onTriggered: weatherService.loadWeather()
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

        if (notificationHistory.count > cleanupThreshold) {
            const removeCount = notificationHistory.count - maxHistoryItems
            notificationHistory.remove(maxHistoryItems, removeCount)
        }
    }

    // Auto-cleanup old notifications
    Timer {
        interval: 1800000
        running: true
        repeat: true
        onTriggered: {
            if (notificationHistory.count > maxHistoryItems) {
                const removeCount = notificationHistory.count - maxHistoryItems
                notificationHistory.remove(maxHistoryItems, removeCount)
            }
        }
    }
}
