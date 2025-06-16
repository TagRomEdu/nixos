import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "root:/settings" as Settings

Rectangle {
    id: calendarRoot
    width: 280
    height: 300
    radius: Settings.Theme.cornerRadius
    color: Settings.Theme.background
    border.color: Settings.Theme.accent
    border.width: 1

    readonly property date currentDate: new Date()
    property int month: currentDate.getMonth()
    property int year: currentDate.getFullYear()
    readonly property int currentDay: currentDate.getDate()

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 12

        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            // Navigation button component
            component NavButton: AbstractButton {
                property alias buttonText: buttonLabel.text
                implicitWidth: 30
                implicitHeight: 30

                background: Rectangle {
                    radius: 15
                    color: parent.down ? Qt.darker(Settings.Theme.accent, 1.2) :
                           parent.hovered ? Qt.lighter(Settings.Theme.selection, 1.1) : Settings.Theme.selection
                }

                Text {
                    id: buttonLabel
                    anchors.centerIn: parent
                    color: Settings.Theme.primaryText
                    font.pixelSize: 16
                    font.bold: true
                    font.family: "JetBrains Mono"
                }
            }

            NavButton {
                buttonText: "◀"
                onClicked: {
                    if (calendarRoot.month === 0) {
                        calendarRoot.month = 11
                        calendarRoot.year--
                    } else {
                        calendarRoot.month--
                    }
                }
            }

            // Current month & year display
            Text {
                text: Qt.locale("en_US").monthName(calendarRoot.month) + " " + calendarRoot.year
                color: Settings.Theme.accent
                font.bold: true
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 18
                font.family: "JetBrains Mono"
            }

            NavButton {
                buttonText: "▶"
                onClicked: {
                    if (calendarRoot.month === 11) {
                        calendarRoot.month = 0
                        calendarRoot.year++
                    } else {
                        calendarRoot.month++
                    }
                }
            }
        }

        Grid {
            columns: 7
            rowSpacing: 4
            columnSpacing: 0
            Layout.leftMargin: 2
            Layout.fillWidth: true

            // Weekday headers, starting Monday
            Repeater {
                model: ["M", "T", "W", "T", "F", "S", "S"]
                delegate: Text {
                    text: modelData
                    color: Settings.Theme.primaryText
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    width: parent.width / 7
                    font.pixelSize: 14
                    font.family: "JetBrains Mono"
                }
            }
        }

        // Main calendar grid for days
        Grid {
            columns: 7
            rowSpacing: 4
            columnSpacing: 4
            Layout.fillWidth: true
            Layout.fillHeight: true

            Repeater {
                model: {
                    let days = []
                    let firstDay = new Date(calendarRoot.year, calendarRoot.month, 1)
                    let lastDay = new Date(calendarRoot.year, calendarRoot.month + 1, 0)
                    
                    // Add days from previous month
                    let firstDayOfWeek = firstDay.getDay() || 7 // Convert Sunday (0) to 7
                    let prevMonthLastDay = new Date(calendarRoot.year, calendarRoot.month, 0).getDate()
                    for (let i = firstDayOfWeek - 1; i > 0; i--) {
                        days.push({
                            day: prevMonthLastDay - i + 1,
                            month: calendarRoot.month - 1,
                            year: calendarRoot.year
                        })
                    }
                    
                    // Add days of current month
                    for (let i = 1; i <= lastDay.getDate(); i++) {
                        days.push({
                            day: i,
                            month: calendarRoot.month,
                            year: calendarRoot.year
                        })
                    }
                    
                    // Add days from next month
                    let remainingDays = 42 - days.length // 6 rows * 7 days
                    for (let i = 1; i <= remainingDays; i++) {
                        days.push({
                            day: i,
                            month: calendarRoot.month + 1,
                            year: calendarRoot.year
                        })
                    }
                    
                    return days
                }

                delegate: Rectangle {
                    width: 30
                    height: 30
                    radius: 15

                    readonly property bool isCurrentMonth: modelData.month === calendarRoot.month
                    readonly property bool isToday: modelData.day === calendarRoot.currentDay &&
                                                   modelData.month === calendarRoot.currentDate.getMonth() &&
                                                   modelData.year === calendarRoot.currentDate.getFullYear() &&
                                                   isCurrentMonth

                    color: isToday ? Settings.Theme.accent :
                           isCurrentMonth ? Settings.Theme.background : Qt.darker(Settings.Theme.background, 1.4)

                    Text {
                        text: modelData.day
                        anchors.centerIn: parent
                        color: isToday ? Settings.Theme.background :
                               isCurrentMonth ? Settings.Theme.primaryText : Qt.darker(Settings.Theme.primaryText, 1.5)
                        font.bold: isToday
                        font.pixelSize: 14
                        font.family: "JetBrains Mono"
                    }
                }
            }
        }
    }
} 