import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import "root:/Data" as Data

Rectangle {
    id: root
    color: Data.Colors.bgColor
    radius: 12
    implicitHeight: 400

    required property var shell
    property bool hovered: false
    property real targetX: 0

    layer.enabled: false

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12

        // Title bar with controls
        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            spacing: 8

            Text {
                text: "Notification History"
                color: Data.Colors.accentColor
                font.pixelSize: 18
                font.bold: true
                font.family: "FiraCode Nerd Font"
            }

            Text {
                text: "(" + (shell.notificationHistory ? shell.notificationHistory.count : 0) + ")"
                color: Data.Colors.fgColor
                font.pixelSize: 12
                opacity: 0.7
            }

            Item { Layout.fillWidth: true }

            Rectangle {
                visible: shell.notificationHistory && shell.notificationHistory.count > 0
                width: clearText.implicitWidth + 16
                height: 24
                radius: 12
                color: clearMouseArea.containsMouse ? Qt.rgba(Data.Colors.accentColor.r, Data.Colors.accentColor.g, Data.Colors.accentColor.b, 0.2) : "transparent"
                border.color: Data.Colors.accentColor
                border.width: 1

                Text {
                    id: clearText
                    anchors.centerIn: parent
                    text: "Clear All"
                    color: Data.Colors.accentColor
                    font.pixelSize: 11
                }

                MouseArea {
                    id: clearMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: shell.notificationHistory.clear()
                }
            }

            Rectangle {
                width: 24
                height: 24
                radius: 12
                color: closeMouseArea.containsMouse ? Qt.rgba(Data.Colors.accentColor.r, Data.Colors.accentColor.g, Data.Colors.accentColor.b, 0.2) : "transparent"
                border.color: Data.Colors.accentColor
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: "×"
                    color: Data.Colors.accentColor
                    font.pixelSize: 16
                }

                MouseArea {
                    id: closeMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: parent.parent.parent.parent.parent.visible = false
                }
            }
        }

        // Scrollable notification list
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            
            ScrollView {
                id: scrollView
                anchors.fill: parent
                clip: true
                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AsNeeded
                    interactive: true
                    visible: notificationListView.contentHeight > notificationListView.height
                    contentItem: Rectangle {
                        implicitWidth: 6
                        radius: width / 2
                        color: parent.pressed ? Data.Colors.accentColor 
                             : parent.hovered ? Qt.lighter(Data.Colors.accentColor, 1.2)
                             : Qt.rgba(Data.Colors.accentColor.r, Data.Colors.accentColor.g, Data.Colors.accentColor.b, 0.7)
                    }
                }
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

                ListView {
                    id: notificationListView
                    model: shell.notificationHistory
                    spacing: 12
                    cacheBuffer: 200
                    reuseItems: true
                    boundsBehavior: Flickable.StopAtBounds
                    maximumFlickVelocity: 2500
                    flickDeceleration: 1500
                    clip: true
                    interactive: true

                    // Smooth scrolling
                    property real targetY: contentY
                    Behavior on targetY {
                        NumberAnimation {
                            duration: 200
                            easing.type: Easing.OutQuad
                        }
                    }

                    onTargetYChanged: {
                        if (!moving && !dragging) {
                            contentY = targetY
                        }
                    }

                    delegate: Rectangle {
                        width: notificationListView.width
                        height: contentLayout.implicitHeight + 24
                        color: Qt.darker(Data.Colors.bgColor, 1.15)
                        radius: 12

                        // Performance optimization
                        visible: y + height > notificationListView.contentY - height && 
                                y < notificationListView.contentY + notificationListView.height + height

                        ColumnLayout {
                            id: contentLayout
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 12

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 8

                                Image {
                                    Layout.preferredWidth: 24
                                    Layout.preferredHeight: 24
                                    source: model.icon || ""
                                    visible: source.toString() !== ""
                                }

                                Text {
                                    Layout.fillWidth: true
                                    text: model.appName || "Unknown"
                                    color: Data.Colors.accentColor
                                    font.pixelSize: 13
                                    font.bold: true
                                }

                                Text {
                                    Layout.rightMargin: 32
                                    text: Qt.formatDateTime(model.timestamp, "hh:mm")
                                    color: Data.Colors.fgColor
                                    font.pixelSize: 10
                                    opacity: 0.7
                                }
                            }

                            Text {
                                Layout.fillWidth: true
                                visible: model.summary && model.summary.length > 0
                                text: model.summary || ""
                                color: Data.Colors.fgColor
                                font.pixelSize: 13
                                font.bold: true
                                wrapMode: Text.WordWrap
                                lineHeight: 1.2
                            }

                            Text {
                                Layout.fillWidth: true
                                visible: model.body && model.body.length > 0
                                text: model.body || ""
                                color: Data.Colors.fgColor
                                font.pixelSize: 12
                                opacity: 0.9
                                wrapMode: Text.WordWrap
                                maximumLineCount: 4
                                elide: Text.ElideRight
                                lineHeight: 1.2
                            }
                        }

                        Rectangle {
                            width: 24
                            height: 24
                            radius: 12
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.margins: 8
                            color: deleteArea.containsMouse ? Qt.rgba(255, 0, 0, 0.2) : "transparent"
                            border.color: deleteArea.containsMouse ? "#ff4444" : Data.Colors.fgColor
                            border.width: 1
                            opacity: deleteArea.containsMouse ? 1 : 0.5

                            Text {
                                anchors.centerIn: parent
                                text: "×"
                                color: deleteArea.containsMouse ? "#ff4444" : Data.Colors.fgColor
                                font.pixelSize: 16
                            }

                            MouseArea {
                                id: deleteArea
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: shell.notificationHistory.remove(model.index)
                            }
                        }
                    }
                }
            }

            Text {
                anchors.centerIn: parent
                visible: !notificationListView.count
                text: "No notifications"
                color: Data.Colors.fgColor
                font.pixelSize: 14
                opacity: 0.7
            }
        }
    }
} 