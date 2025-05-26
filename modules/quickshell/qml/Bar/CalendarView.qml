import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
Rectangle {
    required property var shell

    radius: 20
    
    color: Qt.lighter(shell.bgColor, 1.2)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 12

        // Month header with navigation
        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Button {
                text: ""
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
                    color: parent.down ? Qt.darker(shell.accentColor, 1.2) :
                           parent.hovered ? Qt.lighter(shell.highlightBg, 1.1) : shell.highlightBg
                }
                contentItem: Label {
                    text: parent.text
                    color: shell.fgColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Label {
                text: Qt.locale("en_US").monthName(calendar.month) + " " + calendar.year
                color: shell.accentColor
                font.bold: true
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
            }

            Button {
                text: ""
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
                    color: parent.down ? Qt.darker(shell.accentColor, 1.2) :
                           parent.hovered ? Qt.lighter(shell.highlightBg, 1.1) : shell.highlightBg
                }
                contentItem: Label {
                    text: parent.text
                    color: shell.fgColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }

        // Day names header
        GridLayout {
            columns: 7
            rowSpacing: 4
            columnSpacing: 0
            Layout.leftMargin: 2

            Repeater {
                model: ["S", "M", "T", "W", "T", "F", "S"]
                delegate: Label {
                    text: modelData
                    color: shell.fgColor
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
            locale: Qt.locale("en_US")

             implicitHeight: 400

            delegate: Rectangle {
                width: 30
                height: 30
                radius: 30
                color: model.day === new Date().getDate()
                       && calendar.month === new Date().getMonth()
                       && calendar.year === new Date().getFullYear()
                       ? shell.accentColor
                       : model.month === calendar.month ? shell.highlightBg : Qt.darker(shell.highlightBg, 1.2)

                Label {
                    text: model.day
                    anchors.centerIn: parent
                    color: model.day === new Date().getDate()
                           && calendar.month === new Date().getMonth()
                           && calendar.year === new Date().getFullYear()
                           ? shell.bgColor
                           : model.month === calendar.month ? shell.fgColor : Qt.darker(shell.fgColor, 1.5)
                    font.bold: model.day === new Date().getDate()
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
                color: parent.down ? Qt.darker(shell.accentColor, 1.2) :
                      parent.hovered ? Qt.lighter(shell.highlightBg, 1.1) : shell.highlightBg
            }
            contentItem: Label {
                text: parent.text
                color: shell.fgColor
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
    }
}