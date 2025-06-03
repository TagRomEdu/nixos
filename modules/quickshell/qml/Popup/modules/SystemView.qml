import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Services.UPower
import "root:/Data" as Data

Rectangle {
    required property var shell
    
    // Remove anchors.fill: parent - let the StackLayout manage sizing
    color: Qt.lighter(Data.Colors.bgColor, 1.2)
    radius: 20

    Component.onCompleted: {
        // Set monitoring intervals from settings
        Data.ProcessManager.setMonitoringInterval(Math.min(Data.Settings.cpuRefreshInterval, Data.Settings.ramRefreshInterval))
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16

        Label {
            text: "Resource Monitor"
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

        // CPU Usage Bar
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 4

            RowLayout {
                Layout.fillWidth: true
                
                Label {
                    text: "󰻠 CPU"
                    color: Data.Colors.fgColor
                    font {
                        pixelSize: 14
                        family: "FiraCode Nerd Font"
                    }
                }
                
                Item { Layout.fillWidth: true }
                
                Label {
                    text: Data.ProcessManager.getCpuUsageFormatted()
                    color: Data.Colors.fgColor
                    font {
                        pixelSize: 14
                        family: "FiraCode Nerd Font"
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 8
                radius: 4
                color: Qt.darker(Data.Colors.highlightBg, 1.3)
                border.width: 1
                border.color: Qt.darker(Data.Colors.highlightBg, 1.5)

                Rectangle {
                    width: parent.width * (Data.ProcessManager.cpuUsage / 100)
                    height: parent.height
                    radius: 4
                    color: Data.ProcessManager.cpuUsage > 80 ? "#e74c3c" : Data.ProcessManager.cpuUsage > 60 ? "#f39c12" : "#27ae60"
                    Behavior on width { NumberAnimation { duration: 300 } }
                }
            }
        }

        // RAM Usage Bar
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 4

            RowLayout {
                Layout.fillWidth: true
                
                Label {
                    text: "󰍛 RAM"
                    color: Data.Colors.fgColor
                    font {
                        pixelSize: 14
                        family: "FiraCode Nerd Font"
                    }
                }
                
                Item { Layout.fillWidth: true }
                
                Label {
                    text: Data.ProcessManager.getRamUsageFormatted()
                    color: Data.Colors.fgColor
                    font {
                        pixelSize: 14
                        family: "FiraCode Nerd Font"
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 8
                radius: 4
                color: Qt.darker(Data.Colors.highlightBg, 1.3)
                border.width: 1
                border.color: Qt.darker(Data.Colors.highlightBg, 1.5)

                Rectangle {
                    width: parent.width * (Data.ProcessManager.ramUsage / 100)
                    height: parent.height
                    radius: 4
                    color: Data.ProcessManager.ramUsage > 80 ? "#e74c3c" : Data.ProcessManager.ramUsage > 60 ? "#f39c12" : "#3498db"
                    Behavior on width { NumberAnimation { duration: 300 } }
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
                text: "󰓅 Performance"
                font.family: "FiraCode Nerd Font"
                onClicked: PowerProfiles.profile = PowerProfile.Performance

                background: Rectangle {
                    radius: 20
                    color: PowerProfiles.profile === PowerProfile.Performance
                        ? Data.Colors.accentColor
                        : parent.down ? Qt.darker(Data.Colors.highlightBg, 1.3)
                        : parent.hovered ? Qt.lighter(Data.Colors.highlightBg, 1.1)
                        : Qt.darker(Data.Colors.highlightBg, 1.1)
                    border.width: 1
                    border.color: Qt.darker(Data.Colors.highlightBg, 1.2)
                }

                contentItem: Label {
                    text: parent.text
                    color: PowerProfiles.profile === PowerProfile.Performance ? Data.Colors.bgColor : Data.Colors.fgColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            // Balanced
            Button {
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                text: "󰾅 Balanced"
                font.family: "FiraCode Nerd Font"
                onClicked: PowerProfiles.profile = PowerProfile.Balanced

                background: Rectangle {
                    radius: 20
                    color: PowerProfiles.profile === PowerProfile.Balanced
                        ? Data.Colors.accentColor
                        : parent.down ? Qt.darker(Data.Colors.highlightBg, 1.3)
                        : parent.hovered ? Qt.lighter(Data.Colors.highlightBg, 1.1)
                        : Qt.darker(Data.Colors.highlightBg, 1.1)
                    border.width: 1
                    border.color: Qt.darker(Data.Colors.highlightBg, 1.2)
                }

                contentItem: Label {
                    text: parent.text
                    color: PowerProfiles.profile === PowerProfile.Balanced ? Data.Colors.bgColor : Data.Colors.fgColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            // Power Saver
            Button {
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                text: "󰌪 Power Saver"
                font.family: "FiraCode Nerd Font"
                onClicked: PowerProfiles.profile = PowerProfile.PowerSaver

                background: Rectangle {
                    radius: 20
                    color: PowerProfiles.profile === PowerProfile.PowerSaver
                        ? Data.Colors.accentColor
                        : parent.down ? Qt.darker(Data.Colors.highlightBg, 1.3)
                        : parent.hovered ? Qt.lighter(Data.Colors.highlightBg, 1.1)
                        : Qt.darker(Data.Colors.highlightBg, 1.1)
                    border.width: 1
                    border.color: Qt.darker(Data.Colors.highlightBg, 1.2)
                }

                contentItem: Label {
                    text: parent.text
                    color: PowerProfiles.profile === PowerProfile.PowerSaver ? Data.Colors.bgColor : Data.Colors.fgColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }
}