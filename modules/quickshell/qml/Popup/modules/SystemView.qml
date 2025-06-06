import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Services.UPower
import "root:/Data" as Data
import "root:/Bar/modules" as BarModules
import "root:/Popup/modules" as PopupModules

Rectangle {
    required property var shell

    color: Qt.lighter(Data.Colors.bgColor, 1.2)
    radius: 20

    readonly property alias trayMenu: inlineTrayMenu
    property int baseHeight: 240  
    property int trayMenuHeight: inlineTrayMenu.visible ? inlineTrayMenu.calculatedHeight + 20 : 0
    property int calculatedHeight: baseHeight + trayMenuHeight
    readonly property int contentHeight: calculatedHeight

    Component.onCompleted: {
        // Set monitoring interval based on refresh settings
        Data.ProcessManager.setMonitoringInterval(Math.min(Data.Settings.cpuRefreshInterval, Data.Settings.ramRefreshInterval))
    }

    // onCalculatedHeightChanged can be used to react to size changes if needed
    onCalculatedHeightChanged: {
        // contentHeightChanged signal is available automatically
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16

        // Title
        Label {
            text: "Resource Monitor"
            color: Data.Colors.accentColor
            font.pixelSize: 18
            font.bold: true
            font.family: "FiraCode Nerd Font"
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
            Layout.bottomMargin: 8
        }

        // CPU usage bar
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 4

            RowLayout {
                Layout.fillWidth: true

                Label {
                    text: "󰻠 CPU"
                    color: Data.Colors.fgColor
                    font.pixelSize: 14
                    font.family: "FiraCode Nerd Font"
                }

                Item { Layout.fillWidth: true }

                Label {
                    text: Data.ProcessManager.getCpuUsageFormatted()
                    color: Data.Colors.fgColor
                    font.pixelSize: 14
                    font.family: "FiraCode Nerd Font"
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
                    // Color changes based on usage thresholds
                    color: Data.ProcessManager.cpuUsage > 80 ? "#e74c3c" : Data.ProcessManager.cpuUsage > 60 ? "#f39c12" : "#27ae60"
                    Behavior on width { NumberAnimation { duration: 300 } }
                }
            }
        }

        // RAM usage bar
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 4

            RowLayout {
                Layout.fillWidth: true

                Label {
                    text: "󰍛 RAM"
                    color: Data.Colors.fgColor
                    font.pixelSize: 14
                    font.family: "FiraCode Nerd Font"
                }

                Item { Layout.fillWidth: true }

                Label {
                    text: Data.ProcessManager.getRamUsageFormatted()
                    color: Data.Colors.fgColor
                    font.pixelSize: 14
                    font.family: "FiraCode Nerd Font"
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
                    // Color changes based on usage thresholds
                    color: Data.ProcessManager.ramUsage > 80 ? "#e74c3c" : Data.ProcessManager.ramUsage > 60 ? "#f39c12" : "#3498db"
                    Behavior on width { NumberAnimation { duration: 300 } }
                }
            }
        }

        // Tray header and toggle area
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 8

            Label {
                text: "System Tray"
                color: Data.Colors.accentColor
                font.pixelSize: 16
                font.bold: true
                font.family: "FiraCode Nerd Font"
                Layout.alignment: Qt.AlignHCenter
            }

            Rectangle {
                Layout.fillWidth: true
                height: 40
                radius: 20
                color: Qt.darker(Data.Colors.bgColor, 1.1)
                border.width: 3
                border.color: Qt.darker(Data.Colors.highlightBg, 1.5)

                PopupModules.SystemTray {
                    id: systemTrayModule
                    anchors.centerIn: parent
                    shell: parent.shell
                    bar: parent
                    trayMenu: inlineTrayMenu
                }
            }
        }

        // Inline tray menu
        Rectangle {
            id: inlineTrayMenu
            Layout.fillWidth: true
            Layout.preferredHeight: visible ? calculatedHeight : 0
            clip: true
            color: Data.Colors.bgColor
            border.color: Data.Colors.accentColor
            border.width: 2
            radius: 20
            visible: false
            enabled: visible

            Behavior on Layout.preferredHeight {
                NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
            }

            property QsMenuHandle menu
            property point triggerPoint: Qt.point(0, 0)
            property Item originalParent
            property int totalCount: opener.children ? opener.children.values.length : 0

            // Calculate height dynamically based on item counts
            property int calculatedHeight: {
                if (totalCount === 0) return 40
                var separatorCount = 0
                var regularItemCount = 0

                if (opener.children && opener.children.values) {
                    for (var i = 0; i < opener.children.values.length; i++) {
                        if (opener.children.values[i].isSeparator) {
                            separatorCount++
                        } else {
                            regularItemCount++
                        }
                    }
                }

                var separatorHeight = separatorCount * 12
                var regularItemRows = Math.ceil(regularItemCount / 2)
                var regularItemHeight = regularItemRows * 32
                // Padding included to balance spacing
                return Math.max(80, 35 + separatorHeight + regularItemHeight + 40)
            }

            function toggle() { visible = !visible }
            function show(point, parentItem) { visible = true }
            function hide() { visible = false }

            QsMenuOpener {
                id: opener
                menu: inlineTrayMenu.menu
            }

            Rectangle {
                id: header
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: 35
                color: "transparent"
            }

            GridView {
                id: gridView
                anchors.top: header.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.rightMargin: 20
                anchors.leftMargin: 20
                anchors.topMargin: 8
                anchors.bottomMargin: 32  // bottom margin increased for balance
                cellWidth: width / 2
                cellHeight: 32
                interactive: false
                flow: GridView.FlowLeftToRight
                layoutDirection: Qt.LeftToRight
                enabled: inlineTrayMenu.visible

                model: ScriptModel {
                    values: opener.children ? [...opener.children.values] : []
                }

                delegate: Item {
                    id: entry
                    required property var modelData
                    required property int index

                    width: gridView.cellWidth - 4
                    height: modelData.isSeparator ? 12 : 30

                    Rectangle {
                        anchors.fill: parent
                        anchors.leftMargin: 8
                        anchors.rightMargin: 8
                        anchors.topMargin: 4
                        anchors.bottomMargin: 4
                        visible: modelData.isSeparator
                        color: "transparent"

                        Rectangle {
                            anchors.centerIn: parent
                            width: parent.width * 0.8
                            height: 1
                            color: Qt.darker(Data.Colors.accentColor, 1.5)
                            opacity: 0.6
                        }
                    }

                    Rectangle {
                        id: itemBackground
                        anchors.fill: parent
                        anchors.margins: 2
                        visible: !modelData.isSeparator
                        color: "transparent"
                        radius: 6

                        Behavior on color {
                            ColorAnimation { duration: 150 }
                        }

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 8
                            anchors.rightMargin: 8
                            spacing: 6

                            Image {
                                Layout.preferredWidth: 16
                                Layout.preferredHeight: 16
                                source: modelData?.icon ?? ""
                                visible: (modelData?.icon ?? "") !== ""
                                fillMode: Image.PreserveAspectFit
                            }

                            Text {
                                Layout.fillWidth: true
                                color: {
                                    if (!(modelData?.enabled ?? true)) {
                                        return Qt.darker(Data.Colors.fgColor, 1.8)
                                    } else if (mouseArea.containsMouse) {
                                        return Data.Colors.accentColor
                                    } else {
                                        return Data.Colors.fgColor
                                    }
                                }
                                text: modelData?.text ?? ""
                                font.pixelSize: 11
                                font.family: "FiraCode Nerd Font"
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                                maximumLineCount: 1

                                Behavior on color {
                                    ColorAnimation { duration: 150 }
                                }
                            }
                        }

                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            enabled: (modelData?.enabled ?? true) && inlineTrayMenu.visible && !modelData.isSeparator

                            onEntered: itemBackground.color = Qt.rgba(Data.Colors.accentColor.r, Data.Colors.accentColor.g, Data.Colors.accentColor.b, 0.15)
                            onExited: itemBackground.color = "transparent"
                            onClicked: {
                                modelData.triggered()
                                inlineTrayMenu.hide()
                            }
                        }
                    }
                }
            }

            // Show message if tray empty
            Item {
                anchors.centerIn: gridView
                visible: gridView.count === 0

                Label {
                    anchors.centerIn: parent
                    text: "No tray items available"
                    color: Qt.darker(Data.Colors.fgColor, 2)
                    font.pixelSize: 14
                    font.family: "FiraCode Nerd Font"
                }
            }
        }
    }
}
