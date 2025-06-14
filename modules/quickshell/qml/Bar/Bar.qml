import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Quickshell
import Quickshell.Hyprland
import "root:/Data" as Data
import "root:/Widgets" as Widgets
import "." as Bar

Item {
    id: bar
    width: 42
    height: parent.height

    required property var popup
    required property var shell

    property bool clockHovered: false
    property bool calendarHovered: false
    property bool keepCalendarVisible: false

    Rectangle {
        anchors.fill: parent
        color: Data.Colors.bgColor

        ColumnLayout {
            anchors.fill: parent
            spacing: 16
            anchors {
                topMargin: 18
                bottomMargin: 18
                leftMargin: 2
            }

            Loader {
                id: workspaceLoader
                Layout.alignment: Qt.AlignHCenter
                active: true
                asynchronous: true
                sourceComponent: Widgets.Workspace {
                    shell: bar.shell
                }
            }

            Item {
                Layout.fillHeight: true
            }

            Item {
                id: clockContainer
                Layout.alignment: Qt.AlignHCenter
                width: clockRoot.width
                height: clockRoot.height

                Widgets.Clock {
                    id: clockRoot
                    anchors.fill: parent
                    onShowCalendar: {
                        if (!calendarLoader.active) {
                            calendarLoader.active = true
                            calendarLoader.onStatusChanged = function() {
                                if (calendarLoader.status === Loader.Ready) {
                                    var globalPos = clockContainer.mapToGlobal(Qt.point(clockContainer.width, 0))
                                    calendarLoader.item.targetX = globalPos.x
                                    calendarLoader.item.setHovered(true)
                                    calendarLoader.onStatusChanged = null
                                }
                            }
                        } else if (calendarLoader.item) {
                            var globalPos = clockContainer.mapToGlobal(Qt.point(clockContainer.width, 0))
                            calendarLoader.item.targetX = globalPos.x
                            calendarLoader.item.setHovered(true)
                        }
                        keepCalendarVisible = true
                    }
                    onHideCalendar: {
                        if (calendarLoader.item) {
                            calendarLoader.item.setHovered(false)
                            keepCalendarVisible = false
                            unloadTimer.restart()
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: {
                        bar.clockHovered = true
                        if (!calendarLoader.active) {
                            calendarLoader.active = true
                            calendarLoader.onStatusChanged = function() {
                                if (calendarLoader.status === Loader.Ready) {
                                    var globalPos = clockContainer.mapToGlobal(Qt.point(clockContainer.width, 0))
                                    calendarLoader.item.targetX = globalPos.x
                                    calendarLoader.item.setHovered(true)
                                    calendarLoader.onStatusChanged = null
                                }
                            }
                        } else if (calendarLoader.item) {
                            var globalPos = clockContainer.mapToGlobal(Qt.point(clockContainer.width, 0))
                            calendarLoader.item.targetX = globalPos.x
                            calendarLoader.item.setHovered(true)
                        }
                    }
                    onExited: {
                        bar.clockHovered = false
                        bar.scheduleHide()
                    }
                }
            }
        }
    }

    Loader {
        id: calendarLoader
        active: false
        asynchronous: true
        sourceComponent: Widgets.CalendarPopup {
            shell: bar.shell
        }
    }

    Timer {
        id: unloadTimer
        interval: 5000  // Unload after 5 seconds of being hidden
        onTriggered: {
            if (calendarLoader.item && !calendarLoader.item._visible && !keepCalendarVisible) {
                calendarLoader.active = false
            }
        }
    }

    Timer {
        id: hideTimer
        interval: 200
        onTriggered: {
            if (!clockHovered && !calendarHovered) {
                keepCalendarVisible = false
                if (calendarLoader.item) {
                    calendarLoader.item.setHovered(false)
                    unloadTimer.restart()
                }
            }
        }
    }

    function scheduleHide() {
        hideTimer.start()
    }
}
