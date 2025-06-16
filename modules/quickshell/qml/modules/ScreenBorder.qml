import QtQuick
import QtQuick.Shapes
import Qt5Compat.GraphicalEffects
import "root:/settings/" as Settings

Item {
    id: border

    // Main container for visual elements
    Item {
        id: visualContainer
        anchors.fill: parent
        
        // Background shape
                    Shape {
                id: borderShape
                anchors.fill: parent
                layer.enabled: true
                layer.samples: 8
                smooth: true
                antialiasing: true

                ShapePath {
                    fillColor: Settings.Colors.bgColor
                    strokeWidth: 0
                    fillRule: ShapePath.OddEvenFill

                PathMove { x: 0; y: 0 }
                PathLine { x: width; y: 0 }
                PathLine { x: width; y: height }
                PathLine { x: 0; y: height }
                PathLine { x: 0; y: 0 }

                PathMove {
                    x: Settings.Config.borderWidth
                    y: Settings.Config.borderWidth + Settings.Config.cornerRadius
                }

                PathArc {
                    x: Settings.Config.borderWidth + Settings.Config.cornerRadius
                    y: Settings.Config.borderWidth
                    radiusX: Settings.Config.cornerRadius
                    radiusY: Settings.Config.cornerRadius
                    direction: PathArc.Clockwise
                }

                PathLine {
                    x: width - Settings.Config.borderWidth - Settings.Config.cornerRadius
                    y: Settings.Config.borderWidth
                }

                PathArc {
                    x: width - Settings.Config.borderWidth
                    y: Settings.Config.borderWidth + Settings.Config.cornerRadius
                    radiusX: Settings.Config.cornerRadius
                    radiusY: Settings.Config.cornerRadius
                    direction: PathArc.Clockwise
                }

                PathLine {
                    x: width - Settings.Config.borderWidth
                    y: height - Settings.Config.borderWidth - Settings.Config.cornerRadius
                }

                PathArc {
                    x: width - Settings.Config.borderWidth - Settings.Config.cornerRadius
                    y: height - Settings.Config.borderWidth
                    radiusX: Settings.Config.cornerRadius
                    radiusY: Settings.Config.cornerRadius
                    direction: PathArc.Clockwise
                }

                PathLine {
                    x: Settings.Config.borderWidth + Settings.Config.cornerRadius
                    y: height - Settings.Config.borderWidth
                }

                PathArc {
                    x: Settings.Config.borderWidth
                    y: height - Settings.Config.borderWidth - Settings.Config.cornerRadius
                    radiusX: Settings.Config.cornerRadius
                    radiusY: Settings.Config.cornerRadius
                    direction: PathArc.Clockwise
                }

                PathLine {
                    x: Settings.Config.borderWidth
                    y: Settings.Config.borderWidth + Settings.Config.cornerRadius
                }
            }
        }

        // Inner content area
        Rectangle {
            id: innerArea
            anchors {
                fill: parent
                margins: Settings.Config.borderWidth
            }
            color: "transparent"
            radius: Settings.Config.cornerRadius

            // Shadow effect
            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: -4
                verticalOffset: -4
                radius: 12
                samples: 16
                color: Settings.Colors.withOpacity(Settings.Colors.base00, 0.25)
                cached: true
            }
        }
    }

    // Force immediate update when theme changes
    Connections {
        target: Settings.Colors
        function onIsDarkThemeChanged() {
            borderShape.visible = false
            borderShape.visible = true
        }
    }
}
