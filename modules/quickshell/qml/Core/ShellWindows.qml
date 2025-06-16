import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "root:/Core" as Core
import "root:/settings" as Settings
import "root:/modules" as Modules
import "root:/widgets/panel" as Panel
import "root:/widgets/notification" as Notification
import "root:/widgets" as Widgets

// Manages shell windows across multiple monitors
Item {
    id: shellWindows
    required property var shell
    required property var notificationService

    // Expose properties for compatibility with main shell - use primary screen instance
    readonly property var notificationWindow: primaryShellWindow ? primaryShellWindow.notificationWindow : null
    readonly property var topPanelWindow: primaryShellWindow ? primaryShellWindow.topPanelWindow : null

    // Track primary screen for system-wide features
    property var primaryShellWindow: null

    // Use persistent multi-monitor bars
    Modules.Bar {
        id: persistentBars
    }

    // Create shell windows for each screen
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: shellWindow
            required property var modelData

            screen: modelData
            
            implicitWidth: Screen.width
            implicitHeight: Screen.height
            color: "transparent"
            exclusiveZone: 0

            mask: Region{}

            anchors {
                top: true
                left: true
                bottom: true
                right: true
            }

            // Set primary shell window for system-wide features
            Component.onCompleted: {
                if (modelData === Quickshell.primaryScreen && !shellWindows.primaryShellWindow) {
                    shellWindows.primaryShellWindow = this
                }
            }

            // Screen border with workspace management
            Modules.ScreenBorder {
                anchors {
                    left: parent.left
                    right: parent.right
                    top: parent.top
                    bottom: parent.bottom
                }
            }

            // UI Layer for panels and overlays
            Item {
                id: uiLayer
                anchors.fill: parent
                z: 2

                // Top panel with proper PanelWindow wrapper
                PanelWindow {
                    id: topPanelWindow
                    screen: shellWindow.screen
                    anchors.top: true

                    margins.top: 0
                    implicitWidth: slideBarVisible ? 670 : 360
                    implicitHeight: slideBarVisible ? 600 : 1
                    color: "transparent"
                    exclusiveZone: 0

                    property bool slideBarVisible: false

                    Modules.TopPanel {
                        id: topPanelContent
                        shell: shellWindows.shell
                        anchors.fill: parent
                        onSlideBarVisibilityChanged: function(visible) {
                            topPanelWindow.slideBarVisible = visible
                        }
                    }
                }

                // Notification overlay (only on primary screen)
                PanelWindow {
                    id: notificationWindow
                    screen: shellWindow.screen
                    anchors.top: true
                    anchors.right: true
                    margins.right: 0
                    margins.top: 0
                    implicitWidth: 420
                    implicitHeight: Math.max(notificationPopup.calculatedHeight, 1)
                    color: "transparent"
                    visible: notificationPopup.notificationQueue.length > 0

                    Notification.Notification {
                        id: notificationPopup
                        anchors.fill: parent
                        shell: shellWindows.shell
                        notificationServer: shellWindows.notificationService ? shellWindows.notificationService.notificationServer : null
                    }
                }

                // Primary screen only components
                Widgets.VolumeOSD {
                    shell: shellWindows.shell
                    visible: shellWindow.screen === Quickshell.primaryScreen
                }

                Core.Version {
                    visible: shellWindow.screen === Quickshell.primaryScreen
                }
            }
        }
    }
}
