import QtQuick
import QtQuick.Shapes
import Qt5Compat.GraphicalEffects
import Quickshell
import "root:/settings" as Settings

Scope {
    id: root

    Variants {
        model: Quickshell.screens

        Item {
            id: border
            required property var modelData
            width: parent.width
            height: parent.height

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
                        fillColor: Settings.Theme.background
                        strokeWidth: 0
                        fillRule: ShapePath.OddEvenFill

                        PathMove { x: 0; y: 0 }
                        PathLine { x: borderShape.width; y: 0 }
                        PathLine { x: borderShape.width; y: borderShape.height }
                        PathLine { x: 0; y: borderShape.height }
                        PathLine { x: 0; y: 0 }

                        PathMove {
                            x: Settings.Theme.borderWidth
                            y: Settings.Theme.borderWidth + Settings.Theme.cornerRadius
                        }

                        PathArc {
                            x: Settings.Theme.borderWidth + Settings.Theme.cornerRadius
                            y: Settings.Theme.borderWidth
                            radiusX: Settings.Theme.cornerRadius
                            radiusY: Settings.Theme.cornerRadius
                            direction: PathArc.Clockwise
                        }

                        PathLine {
                            x: borderShape.width - Settings.Theme.borderWidth - Settings.Theme.cornerRadius
                            y: Settings.Theme.borderWidth
                        }

                        PathArc {
                            x: borderShape.width - Settings.Theme.borderWidth
                            y: Settings.Theme.borderWidth + Settings.Theme.cornerRadius
                            radiusX: Settings.Theme.cornerRadius
                            radiusY: Settings.Theme.cornerRadius
                            direction: PathArc.Clockwise
                        }

                        PathLine {
                            x: borderShape.width - Settings.Theme.borderWidth
                            y: borderShape.height - Settings.Theme.borderWidth - Settings.Theme.cornerRadius
                        }

                        PathArc {
                            x: borderShape.width - Settings.Theme.borderWidth - Settings.Theme.cornerRadius
                            y: borderShape.height - Settings.Theme.borderWidth
                            radiusX: Settings.Theme.cornerRadius
                            radiusY: Settings.Theme.cornerRadius
                            direction: PathArc.Clockwise
                        }

                        PathLine {
                            x: Settings.Theme.borderWidth + Settings.Theme.cornerRadius
                            y: borderShape.height - Settings.Theme.borderWidth
                        }

                        PathArc {
                            x: Settings.Theme.borderWidth
                            y: borderShape.height - Settings.Theme.borderWidth - Settings.Theme.cornerRadius
                            radiusX: Settings.Theme.cornerRadius
                            radiusY: Settings.Theme.cornerRadius
                            direction: PathArc.Clockwise
                        }

                        PathLine {
                            x: Settings.Theme.borderWidth
                            y: Settings.Theme.borderWidth + Settings.Theme.cornerRadius
                        }
                    }
                }

                // Inner content area
                Rectangle {
                    id: innerArea
                    anchors {
                        fill: parent
                        margins: Settings.Theme.borderWidth
                    }
                    color: "transparent"
                    radius: Settings.Theme.cornerRadius

                    // Shadow effect
                    layer.enabled: true
                    layer.effect: DropShadow {
                        transparentBorder: true
                        horizontalOffset: -4
                        verticalOffset: -4
                        radius: 12
                        samples: 16
                        color: Qt.rgba(0, 0, 0, 0.25)
                        cached: true
                    }
                }
            }
        }
    }
} 