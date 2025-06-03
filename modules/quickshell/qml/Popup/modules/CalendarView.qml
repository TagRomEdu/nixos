import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "root:/Data" as Data

Rectangle {
    required property var shell
    
    radius: 20
    color: Qt.lighter(Data.Colors.bgColor, 1.2)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 12

        // Month header with navigation
        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Button {
                text: "‹"
                onClicked: {
                    if (calendar.month === 0) {
                        calendar.month = 11
                        calendar.year -= 1
                    } else {
                        calendar.month -= 1
                    }
                }
                implicitWidth: 30
                background: Rectangle {
                    radius: 20
                    color: parent.down ? Qt.darker(Data.Colors.accentColor, 1.2) :
                           parent.hovered ? Qt.lighter(Data.Colors.highlightBg, 1.1) : Data.Colors.highlightBg
                }
                contentItem: Label {
                    text: parent.text
                    color: Data.Colors.fgColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Label {
                text: Qt.locale("en_US").monthName(calendar.month) + " " + calendar.year
                color: Data.Colors.accentColor
                font.bold: true
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
            }

            Button {
                text: "›"
                onClicked: {
                    if (calendar.month === 11) {
                        calendar.month = 0
                        calendar.year += 1
                    } else {
                        calendar.month += 1
                    }
                }
                implicitWidth: 30
                background: Rectangle {
                    radius: 20
                    color: parent.down ? Qt.darker(Data.Colors.accentColor, 1.2) :
                           parent.hovered ? Qt.lighter(Data.Colors.highlightBg, 1.1) : Data.Colors.highlightBg
                }
                contentItem: Label {
                    text: parent.text
                    color: Data.Colors.fgColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }

        // Day names header - Monday to Sunday
        GridLayout {
            columns: 7
            rowSpacing: 4
            columnSpacing: 0
            Layout.leftMargin: 2

            Repeater {
                model: ["M", "T", "W", "T", "F", "S", "S"]
                delegate: Label {
                    text: modelData
                    color: Data.Colors.fgColor
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    Layout.preferredWidth: 30
                    Layout.fillWidth: true
                }
            }
        }

        // Calendar grid
        MonthGrid {
            id: calendar
            month: new Date().getMonth()
            year: new Date().getFullYear()
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 4
            leftPadding: 0
            rightPadding: 0
            
            // Create custom locale with Monday as first day of week
            locale: Qt.locale("de_DE")  // German locale starts with Monday by default
            
            implicitHeight: 400

            delegate: Rectangle {
                width: 30
                height: 30
                radius: 30
                
                // Fixed: Only highlight today if it's in the current displayed month AND it's actually today
                readonly property bool isToday: model.day === new Date().getDate()
                                              && model.month === new Date().getMonth()
                                              && calendar.year === new Date().getFullYear()
                                              && model.month === calendar.month  // This was missing!
                
                color: isToday
                       ? Data.Colors.accentColor
                       : model.month === calendar.month ? Data.Colors.highlightBg : Qt.darker(Data.Colors.highlightBg, 1.2)

                Label {
                    text: model.day
                    anchors.centerIn: parent
                    color: parent.isToday
                           ? Data.Colors.bgColor
                           : model.month === calendar.month ? Data.Colors.fgColor : Qt.darker(Data.Colors.fgColor, 1.5)
                    font.bold: parent.isToday
                }
            }
        }

        // Today button
        Button {
            text: "Today"
            onClicked: {
                calendar.month = new Date().getMonth()
                calendar.year = new Date().getFullYear()
            }
            Layout.fillWidth: true
            background: Rectangle {
                radius: 20
                color: parent.down ? Qt.darker(Data.Colors.accentColor, 1.2) :
                      parent.hovered ? Qt.lighter(Data.Colors.highlightBg, 1.1) : Data.Colors.highlightBg
            }
            contentItem: Label {
                text: parent.text
                color: Data.Colors.fgColor
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
    }
}