pragma Singleton

import QtQuick

QtObject {
    // Base colors
    readonly property color base00: "#141414"    // Near-black background, OLED friendly
    readonly property color base01: "#1e1e24"    // Slightly lighter background for panels
    readonly property color base02: "#2a2a32"    // Subtle contrast for selections
    readonly property color base03: "#545466"    // Muted text and borders
    readonly property color base04: "#9395a5"    // Secondary text
    readonly property color base05: "#e2e4ef"    // Primary text, not pure white
    readonly property color base06: "#eceef7"    // Bright text, still gentle
    readonly property color base07: "#f7f9ff"    // Brightest text, used sparingly

    // Accent colors
    readonly property color base08: "#f0707e"    // Soft red for errors
    readonly property color base09: "#f5a97f"    // Warm orange for warnings
    readonly property color base0A: "#f5d767"    // Soft yellow for highlights
    readonly property color base0B: "#8ccf7e"    // Gentle green for success
    readonly property color base0C: "#79dac8"    // Cyan for info/links
    readonly property color base0D: "#86aaec"    // Calm blue for primary actions
    readonly property color base0E: "#c488ec"    // Soft purple for accents
    readonly property color base0F: "#f4a4be"    // Pink for special elements

    // Semantic color aliases for easier use
    readonly property color background: base00
    readonly property color panelBackground: base01
    readonly property color selection: base02
    readonly property color border: base03
    readonly property color secondaryText: base04
    readonly property color primaryText: base05
    readonly property color brightText: base06
    readonly property color brightestText: base07

    readonly property color error: base08
    readonly property color warning: base09
    readonly property color highlight: base0A
    readonly property color success: base0B
    readonly property color info: base0C
    readonly property color primary: base0D
    readonly property color accent: base0E
    readonly property color special: base0F

    readonly property real borderWidth: 9
    readonly property real cornerRadius: 20
} 