import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower
import "../Data" as Data

Rectangle {
    required property var shell  // Keeping for ProcessManager functionality
    
    anchors.fill: parent
    color: Qt.lighter(Data.Colors.bgColor, 1.2)
    radius: 20

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16
        Layout.alignment: Qt.AlignHCenter

        Label {
            text: "System Controls"
            color: Data.Colors.accentColor
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
                    color: parent.down ? Qt.darker(Data.Colors.highlightBg, 1.3) :
                           parent.hovered ? Qt.lighter(Data.Colors.highlightBg, 1.1) : Data.Colors.highlightBg
                    border.width: 1
                    border.color: Qt.darker(Data.Colors.highlightBg, 1.2)
                }

                onClicked: Data.ProcessManager.shutdown()

                contentItem: Label {
                    text: parent.text
                    color: Data.Colors.fgColor
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
                background: Rectangle {
                    radius: 20
                    color: parent.down ? Qt.darker(Data.Colors.highlightBg, 1.3) :
                           parent.hovered ? Qt.lighter(Data.Colors.highlightBg, 1.1) : Data.Colors.highlightBg
                    border.width: 1
                    border.color: Qt.darker(Data.Colors.highlightBg, 1.2)
                }

                onClicked: Data.ProcessManager.reboot()

                contentItem: Label {
                    text: parent.text
                    color: Data.Colors.fgColor
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
                background: Rectangle {
                    radius: 20
                    color: parent.down ? Qt.darker(Data.Colors.highlightBg, 1.3) :
                           parent.hovered ? Qt.lighter(Data.Colors.highlightBg, 1.1) : Data.Colors.highlightBg
                    border.width: 1
                    border.color: Qt.darker(Data.Colors.highlightBg, 1.2)
                }

                onClicked: Data.ProcessManager.lock()

                contentItem: Label {
                    text: parent.text
                    color: Data.Colors.fgColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.fill: parent
                }
            }
        }

        Label {
            text: "Power Profile"
            color: Data.Colors.accentColor
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
                        ? Data.Colors.accentColor
                        : parent.down ? Qt.darker(Data.Colors.highlightBg, 1.3)
                        : parent.hovered ? Qt.lighter(Data.Colors.highlightBg, 1.1)
                        : Data.Colors.highlightBg
                    border.width: 1
                    border.color: Qt.darker(Data.Colors.highlightBg, 1.2)
                }

                contentItem: Label {
                    text: parent.text
                    color: PowerProfiles.profile === PowerProfile.Performance ? Data.Colors.bgColor : Data.Colors.fgColor
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
                        ? Data.Colors.accentColor
                        : parent.down ? Qt.darker(Data.Colors.highlightBg, 1.3)
                        : parent.hovered ? Qt.lighter(Data.Colors.highlightBg, 1.1)
                        : Data.Colors.highlightBg
                    border.width: 1
                    border.color: Qt.darker(Data.Colors.highlightBg, 1.2)
                }

                contentItem: Label {
                    text: parent.text
                    color: PowerProfiles.profile === PowerProfile.Balanced ? Data.Colors.bgColor : Data.Colors.fgColor
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
                        ? Data.Colors.accentColor
                        : parent.down ? Qt.darker(Data.Colors.highlightBg, 1.3)
                        : parent.hovered ? Qt.lighter(Data.Colors.highlightBg, 1.1)
                        : Data.Colors.highlightBg
                    border.width: 1
                    border.color: Qt.darker(Data.Colors.highlightBg, 1.2)
                }

                contentItem: Label {
                    text: parent.text
                    color: PowerProfiles.profile === PowerProfile.PowerSaver ? Data.Colors.bgColor : Data.Colors.fgColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.fill: parent
                }
            }
        }
    }
}