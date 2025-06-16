import Quickshell
import QtQuick
import QtQuick.Controls
import "root:/settings" as Settings

Item {
  id: root
  width: 200
  height: 30
  readonly property string hours: Qt.formatDateTime(clock.date, "HH")
  readonly property string minutes: Qt.formatDateTime(clock.date, "mm")

  SystemClock {
    id: clock
    precision: SystemClock.Minutes
  }

  signal showCalendar()
  signal hideCalendar()

  MouseArea {
    id: mouseArea
    anchors.fill: parent
    hoverEnabled: true
    onEntered: {
      console.log("Mouse entered TimeDisplay")
      showCalendar()
    }
    onExited: {
      console.log("Mouse exited TimeDisplay")
      hideCalendar()
    }
  }

  Text {
    id: timeText
    anchors.centerIn: parent
    text: root.hours + ":" + root.minutes
    color: Settings.Theme.primaryText
    font.family: "JetBrains Mono"
    font.pixelSize: 14
  }

  // Debug info
  Text {
    visible: true
    text: "TimeDisplay\nHover: " + mouseArea.containsMouse
    color: "red"
    font.family: "JetBrains Mono"
    font.pixelSize: 12
  }
} 