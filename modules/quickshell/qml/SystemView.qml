import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io

Rectangle {
    required property var shell
    anchors.fill: parent
    color: Qt.lighter(shell.bgColor, 1.2)
    radius: 20

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16
        // Center the whole ColumnLayout content horizontally
        Layout.alignment: Qt.AlignHCenter

        Label {
            text: "System Controls"
            color: shell.accentColor
            font {
                pixelSize: 18
                bold: true
                family: "FiraCode Nerd Font"
            }
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
            Layout.bottomMargin: 8
        }

        // Main power buttons
        GridLayout {
            columns: 3
            columnSpacing: 16
            rowSpacing: 16
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignHCenter

            Process {
                id: shutdown
                command: ["shutdown", "-h", "now"]
            } 
            Process {
                id: reboot
                command: ["reboot"]
            }

            // Lock button
            Button {
                Layout.fillWidth: true
                Layout.fillHeight: true
                onClicked: Shell.execute("loginctl lock-session")

                background: Rectangle {
                    radius: 20
                    color: parent.down ? Qt.darker(shell.highlightBg, 1.3) :
                           parent.hovered ? Qt.lighter(shell.highlightBg, 1.1) : shell.highlightBg
                    border.width: 1
                    border.color: Qt.darker(shell.highlightBg, 1.2)
                }

                contentItem: Column {
                    spacing: 8
                    anchors.centerIn: parent

                    Label {
                        text: ""
                        font {
                            family: "FiraCode Nerd Font"
                            pixelSize: 28
                        }
                        color: shell.fgColor
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }

            // Restart button
            Button {
                Layout.fillWidth: true
                Layout.fillHeight: true
                onClicked: reboot.running = true

                background: Rectangle {
                    radius: 20
                    color: parent.down ? Qt.darker(shell.highlightBg, 1.3) :
                           parent.hovered ? Qt.lighter(shell.highlightBg, 1.1) : shell.highlightBg
                    border.width: 1
                    border.color: Qt.darker(shell.highlightBg, 1.2)
                }

                contentItem: Column {
                    spacing: 8
                    anchors.centerIn: parent

                    Label {
                        text: ""
                        font {
                            family: "FiraCode Nerd Font"
                            pixelSize: 28
                        }
                        color: shell.fgColor
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }

            // Shutdown button                         
            Button {
                Layout.fillWidth: true
                Layout.fillHeight: true
                onClicked: shutdown.running = true

                background: Rectangle {
                    radius: 20
                    color: parent.down ? Qt.darker(shell.highlightBg, 1.3) :
                           parent.hovered ? Qt.lighter(shell.highlightBg, 1.1) : shell.highlightBg
                    border.width: 1
                    border.color: Qt.darker(shell.highlightBg, 1.2)
                }

                contentItem: Column {
                    spacing: 8
                    anchors.centerIn: parent

                    Label {
                        text: ""
                        font {
                            family: "FiraCode Nerd Font"
                            pixelSize: 28
                        }
                        color: shell.fgColor
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }

        // Secondary controls
        RowLayout {
            Layout.fillWidth: true
            spacing: 8
            Layout.alignment: Qt.AlignHCenter  // center the row itself horizontally

            Button {
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            text: ""
            font.family: "FiraCode Nerd Font"
            onClicked: Shell.execute("systemctl suspend")

            background: Rectangle {
                radius: 20
                color: parent.down ? Qt.darker(shell.highlightBg, 1.3) :
                   parent.hovered ? Qt.lighter(shell.highlightBg, 1.1) : shell.highlightBg
                border.width: 1
                border.color: Qt.darker(shell.highlightBg, 1.2)
            }

            contentItem: Label {
                text: parent.text
                color: shell.fgColor
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.fill: parent
            }
            }

            Button {
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            text: ""
            font.family: "FiraCode Nerd Font"
            onClicked: Shell.execute("loginctl terminate-user $USER")

            background: Rectangle {
                radius: 20
                color: parent.down ? Qt.darker(shell.highlightBg, 1.3) :
                   parent.hovered ? Qt.lighter(shell.highlightBg, 1.1) : shell.highlightBg
                border.width: 1
                border.color: Qt.darker(shell.highlightBg, 1.2)
            }

            contentItem: Label {
                text: parent.text
                color: shell.fgColor
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.fill: parent
            }
            }
        }
    }
}
