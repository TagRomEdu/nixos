import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower
import "../Data/" as Dat

Rectangle {
    required property var shell
    anchors.fill: parent
    color: Qt.lighter(shell.bgColor, 1.2)
    radius: 20

    Process {
        id: shutdown
        command: ["shutdown", "-h", "now"]
    }

    Process {
        id: reboot
        command: ["reboot"]
    }
    Process {
        id: lock
        command: ["hyprlock"]
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16
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

        RowLayout {
            Layout.fillWidth: true
            spacing: 8
            Layout.alignment: Qt.AlignHCenter

            Button {
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                text: "󰐥"
                font.family: "FiraCode Nerd Font"
                background: Rectangle {
                    radius: 20
                    color: parent.down ? Qt.darker(shell.highlightBg, 1.3) :
                           parent.hovered ? Qt.lighter(shell.highlightBg, 1.1) : shell.highlightBg
                    border.width: 1
                    border.color: Qt.darker(shell.highlightBg, 1.2)
                }

                onClicked: shutdown.running = true

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
                text: ""
                font.family: "FiraCode Nerd Font"
                // Logout button?
                background: Rectangle {
                    radius: 20
                    color: parent.down ? Qt.darker(shell.highlightBg, 1.3) :
                           parent.hovered ? Qt.lighter(shell.highlightBg, 1.1) : shell.highlightBg
                    border.width: 1
                    border.color: Qt.darker(shell.highlightBg, 1.2)
                }

                onClicked: reboot.running = true

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
                text: ""
                font.family: "FiraCode Nerd Font"
                // Logout button?
                background: Rectangle {
                    radius: 20
                    color: parent.down ? Qt.darker(shell.highlightBg, 1.3) :
                           parent.hovered ? Qt.lighter(shell.highlightBg, 1.1) : shell.highlightBg
                    border.width: 1
                    border.color: Qt.darker(shell.highlightBg, 1.2)
                }

                onClicked: lock.running = true

                contentItem: Label {
                    text: parent.text
                    color: shell.fgColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.fill: parent
                }
            }
            
        }

        Label {
            text: "Power Profile"
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

        RowLayout {
            Layout.fillWidth: true
            spacing: 8
            Layout.alignment: Qt.AlignHCenter

            // Performance
            Button {
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                text: ""
                font.family: "FiraCode Nerd Font"
                onClicked: PowerProfiles.profile = (
                    PowerProfiles.profile !== PowerProfile.Performance
                        ? PowerProfile.Performance
                        : PowerProfile.Balanced
                )

                background: Rectangle {
                    radius: 20
                    color: PowerProfiles.profile === PowerProfile.Performance
                        ? shell.accentColor
                        : parent.down ? Qt.darker(shell.highlightBg, 1.3)
                        : parent.hovered ? Qt.lighter(shell.highlightBg, 1.1)
                        : shell.highlightBg
                    border.width: 1
                    border.color: Qt.darker(shell.highlightBg, 1.2)
                }

                contentItem: Label {
                    text: parent.text
                    color: PowerProfiles.profile === PowerProfile.Performance ? shell.bgColor : shell.fgColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.fill: parent
                }
            }

            // Balanced
            Button {
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                text: ""
                font.family: "FiraCode Nerd Font"
                onClicked: PowerProfiles.profile = PowerProfile.Balanced

                background: Rectangle {
                    radius: 20
                    color: PowerProfiles.profile === PowerProfile.Balanced
                        ? shell.accentColor
                        : parent.down ? Qt.darker(shell.highlightBg, 1.3)
                        : parent.hovered ? Qt.lighter(shell.highlightBg, 1.1)
                        : shell.highlightBg
                    border.width: 1
                    border.color: Qt.darker(shell.highlightBg, 1.2)
                }

                contentItem: Label {
                    text: parent.text
                    color: PowerProfiles.profile === PowerProfile.Balanced ? shell.bgColor : shell.fgColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.fill: parent
                }
            }

            // Power Saver
            Button {
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                text: "󰌪"
                font.family: "FiraCode Nerd Font"
                onClicked: PowerProfiles.profile = (
                    PowerProfiles.profile !== PowerProfile.PowerSaver
                        ? PowerProfile.PowerSaver
                        : PowerProfile.Balanced
                )

                background: Rectangle {
                    radius: 20
                    color: PowerProfiles.profile === PowerProfile.PowerSaver
                        ? shell.accentColor
                        : parent.down ? Qt.darker(shell.highlightBg, 1.3)
                        : parent.hovered ? Qt.lighter(shell.highlightBg, 1.1)
                        : shell.highlightBg
                    border.width: 1
                    border.color: Qt.darker(shell.highlightBg, 1.2)
                }

                contentItem: Label {
                    text: parent.text
                    color: PowerProfiles.profile === PowerProfile.PowerSaver ? shell.bgColor : shell.fgColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.fill: parent
                }
            }
        }
    }
}
