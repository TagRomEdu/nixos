import Quickshell
import Quickshell.Io
import QtQuick

import "root:/settings" as Settings
import "root:/widgets/bar" as Modules

Scope {
  id: root
  readonly property string hours: Qt.formatDateTime(clock.date, "HH")
  readonly property string minutes: Qt.formatDateTime(clock.date, "mm")
  property bool clockHovered: false
  property bool calendarHovered: false
  property bool keepCalendarVisible: false

  SystemClock {
    id: clock
    precision: SystemClock.Minutes
  }

  Variants {
    model: Quickshell.screens

    PanelWindow {
      property var modelData
      screen: modelData

      anchors {
        top: true
        left: true
        bottom: true
      }

      implicitWidth: 30
      color: Settings.Colors.bgColor

      Column {
        anchors {
          fill: parent
          topMargin: 16
        }
        spacing: 8

        Item {
          width: parent.width + Settings.Theme.borderWidth - 1
          height: parent.height - y - 8

          Modules.WorkspaceIndicator {
            width: parent.width
          }

          Modules.Clock {
            id: clockRoot
            anchors.bottom: parent.bottom
            width: parent.width
            onShowCalendar: {
              keepCalendarVisible = true
              if (!calendarLoader.active) {
                calendarLoader.active = true
              }
              // Position calendar when it becomes ready
              if (calendarLoader.item) {
                var globalPos = clockRoot.mapToGlobal(Qt.point(clockRoot.width, 0))
                calendarLoader.item.targetX = globalPos.x
                calendarLoader.item.setHovered(true)
              }
            }
            onHideCalendar: {
              if (calendarLoader.item) {
                calendarLoader.item.setHovered(false)
                keepCalendarVisible = false
                unloadTimer.restart()
              }
            }
          }
        }
      }

      Loader {
        id: calendarLoader
        active: false
        asynchronous: true
        sourceComponent: Modules.CalendarPopup {}
      }

      // Handle calendar positioning when loader becomes ready
      Connections {
        target: calendarLoader
        function onStatusChanged() {
          if (calendarLoader.status === Loader.Ready && calendarLoader.item && keepCalendarVisible) {
            var globalPos = clockRoot.mapToGlobal(Qt.point(clockRoot.width, 0))
            calendarLoader.item.targetX = globalPos.x
            calendarLoader.item.setHovered(true)
          }
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
  }
}