import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Services.Notifications

Item {
    required property var shell
    property var notification: null
    property var notificationQueue: []
    property var currentNotification: null
    property int displayTime: 5000
    property int calculatedHeight: Math.min(600, calculateHeight()) // Max height 600px
    property int maxWidth: 400

    required property var notificationServer

    Connections {
        target: notificationServer
        
        function onNotification(notification) {
            notification.tracked = true
            notificationQueue.push(notification)
        }
    }

    Rectangle {
        id: notificationContainer
        width: maxWidth
        height: calculatedHeight
        color: shell.bgColor
        radius: 20
        border.width: 3
        border.color: shell.accentColor

        

        ColumnLayout {
            id: notificationContent
            width: parent.width - 24
            anchors.centerIn: parent
            spacing: 8

            RowLayout {
                Layout.fillWidth: true
                spacing: 12

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

            Text {
                text: notification?.summary || ""
                color: shell.fgColor
                font.bold: true
                font.pixelSize: 14
                wrapMode: Text.Wrap
                Layout.fillWidth: true
                visible: text !== ""
            }

            Text {
                text: notification?.body || ""
                color: shell.fgColor
                wrapMode: Text.Wrap
                Layout.fillWidth: true
                Layout.maximumWidth: parent.width
            }

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

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
            }
        }

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

    function calculateHeight() {
        let h = 0;
        // Add heights of all visible children plus spacing
        for (let i = 0; i < notificationContent.children.length; i++) {
            const child = notificationContent.children[i];
            if (child.visible && child.Layout) {
                h += child.implicitHeight + notificationContent.spacing;
            }
        }
        return h + 24; // Add padding
    }

    onNotificationChanged: {
        if (notification) {
            notificationContent.forceLayout();
            Qt.callLater(() => {
                calculatedHeight = calculateHeight();
            });
        }
    }
}