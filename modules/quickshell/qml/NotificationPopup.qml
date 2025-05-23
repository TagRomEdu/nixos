import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Services.Notifications

Item {
    required property var shell
    property var notification: null

    property var notificationQueue: []
    property var currentNotification: null
    property int displayTime: 5000 // 5 seconds

    required property var notificationServer

    // Connect to the notification server
    Connections {
        target: notificationServer
        
        function onNotification(notification) {
            notification.tracked = true
            notificationQueue.push(notification)
        }
    }

    // Notification container
    Rectangle {
        id: notificationContainer
        width: 400
        height: notificationContent.height + 24
        color: shell.bgColor
        radius: 8
        border.width: 3
        border.color: shell.accentColor

        

        ColumnLayout {
            id: notificationContent
            width: parent.width - 24
            anchors.centerIn: parent
            spacing: 8

            // Header with app name and time
            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                // App icons not working yet
                Image {
                    source: {
                        let icon = notification?.appIcon || "";
                        if (icon.includes("?path=")) {
                            const [name, path] = icon.split("?path=");
                            const fileName = name.substring(name.lastIndexOf("/") + 1);
                            return `file://${path}/${fileName}`;
                        }
                        return icon;
                    }
                    sourceSize: Qt.size(32, 32)
                    visible: source.toString() !== ""
                    Layout.preferredWidth: 32
                    Layout.preferredHeight: 32
                    onStatusChanged: {
                        if (status === Image.Error) {
                            console.log("Failed to load notification icon:", source)
                        }
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2

                    Text {
                        text: notification?.appName || "Notification"
                        color: shell.accentColor
                        font.bold: true
                        font.pixelSize: 14
                        elide: Text.ElideRight
                    }

                    Text {
                        text: Qt.formatDateTime(new Date(), "hh:mm AP")
                        color: Qt.lighter(shell.fgColor, 1.4)
                        font.pixelSize: 10
                    }
                }
            }

            // Notification body
            Text {
                text: notification?.body || ""
                color: shell.fgColor
                wrapMode: Text.Wrap
                Layout.fillWidth: true
                Layout.maximumWidth: parent.width
            }

            // Notification image (if available)
            Image {
                source: {
                    let icon = notification?.image || "";
                    if (icon.includes("?path=")) {
                        const [name, path] = icon.split("?path=");
                        const fileName = name.substring(name.lastIndexOf("/") + 1);
                        return `file://${path}/${fileName}`;
                    }
                    return icon;
                }
                sourceSize.width: parent.width
                fillMode: Image.PreserveAspectFit
                visible: !!source && source.toString() !== "" && !!NotificationServer?.imageSupported
                Layout.maximumHeight: 180
                Layout.fillWidth: true
                onStatusChanged: {
                    if (status === Image.Error) {
                        console.log("Failed to load notification image:", source)
                    }
                }
            }

            // Actions row
            RowLayout {
                visible: notification?.actions?.length > 0 && 
                         NotificationServer.actionsSupported
                spacing: 8
                Layout.alignment: Qt.AlignRight

                Repeater {
                    model: notification?.actions || []

                    Button {
                        text: modelData.label
                        flat: true
                        onClicked: {
                            modelData.invoke()
                            notificationWindow.visible = false
                        }

                        background: Rectangle {
                            radius: 16
                            color: parent.pressed ? Qt.darker(shell.highlightBg, 1.2) :
                                   parent.hovered ? shell.highlightBg : "transparent"
                        }

                        contentItem: Text {
                            text: parent.text
                            color: shell.accentColor
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }
            }
        }

        // Close button
        Button {
            anchors {
                top: parent.top
                right: parent.right
                margins: 8
            }
            width: 24
            height: 24
            flat: true

            onClicked: notificationWindow.visible = false

            contentItem: Text {
                text: "×"
                color: shell.fgColor
                font.pixelSize: 18
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
    }
}