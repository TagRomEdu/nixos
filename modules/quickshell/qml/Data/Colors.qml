pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import "." as Data

Singleton {
    id: colors

    // Dark Theme - OLED friendly with rich, deep colors
    readonly property var darkTheme: ({
        base00: "#141414",    // Near-black background, OLED friendly
        base01: "#1e1e24",    // Slightly lighter background for panels
        base02: "#2a2a32",    // Subtle contrast for selections
        base03: "#545466",    // Muted text and borders
        base04: "#9395a5",    // Secondary text
        base05: "#e2e4ef",    // Primary text, not pure white
        base06: "#eceef7",    // Bright text, still gentle
        base07: "#f7f9ff",    // Brightest text, used sparingly
        base08: "#f0707e",    // Soft red for errors
        base09: "#f5a97f",    // Warm orange for warnings
        base0A: "#f5d767",    // Soft yellow for highlights
        base0B: "#8ccf7e",    // Gentle green for success
        base0C: "#79dac8",    // Cyan for info/links
        base0D: "#86aaec",    // Calm blue for primary actions
        base0E: "#c488ec",    // Soft purple for accents
        base0F: "#f4a4be"     // Pink for special elements
    })

    // Light Theme - Clean and professional
    readonly property var lightTheme: ({
        base00: "#fafafa",    // Clean white background
        base01: "#f0f1f4",    // Subtle panel background
        base02: "#e4e6ed",    // Selection/hover background
        base03: "#9699aa",    // Subdued text/icons
        base04: "#535773",    // Secondary text
        base05: "#2c324a",    // Primary text
        base06: "#1c2033",    // Strong text
        base07: "#0f111a",    // Strongest text
        base08: "#d95468",    // Vibrant red
        base09: "#e87c3e",    // Bright orange
        base0A: "#d98e48",    // Warm amber
        base0B: "#34a461",    // Fresh green
        base0C: "#26a6a6",    // Teal
        base0D: "#4876d6",    // Royal blue
        base0E: "#8a3fdc",    // Rich purple
        base0F: "#f4a4be"     // Pastel pink (matching dark theme)
    })

    // Dynamic color properties that update based on current theme
    readonly property color base00: isDarkTheme ? darkTheme.base00 : lightTheme.base00
    readonly property color base01: isDarkTheme ? darkTheme.base01 : lightTheme.base01
    readonly property color base02: isDarkTheme ? darkTheme.base02 : lightTheme.base02
    readonly property color base03: isDarkTheme ? darkTheme.base03 : lightTheme.base03
    readonly property color base04: isDarkTheme ? darkTheme.base04 : lightTheme.base04
    readonly property color base05: isDarkTheme ? darkTheme.base05 : lightTheme.base05
    readonly property color base06: isDarkTheme ? darkTheme.base06 : lightTheme.base06
    readonly property color base07: isDarkTheme ? darkTheme.base07 : lightTheme.base07
    readonly property color base08: isDarkTheme ? darkTheme.base08 : lightTheme.base08
    readonly property color base09: isDarkTheme ? darkTheme.base09 : lightTheme.base09
    readonly property color base0A: isDarkTheme ? darkTheme.base0A : lightTheme.base0A
    readonly property color base0B: isDarkTheme ? darkTheme.base0B : lightTheme.base0B
    readonly property color base0C: isDarkTheme ? darkTheme.base0C : lightTheme.base0C
    readonly property color base0D: isDarkTheme ? darkTheme.base0D : lightTheme.base0D
    readonly property color base0E: isDarkTheme ? darkTheme.base0E : lightTheme.base0E
    readonly property color base0F: isDarkTheme ? darkTheme.base0F : lightTheme.base0F

    // Functional color mappings
    readonly property color bgColor: base00      // Main background
    readonly property color bgLight: base01      // Lighter background elements
    readonly property color bgLighter: base02    // Highlighted background elements
    readonly property color fgColor: base04      // Regular text
    readonly property color fgColorBright: base05 // Bright text for emphasis
    readonly property color accentColor: base0E      // Primary accent
    readonly property color accentColorBright: base0D // Secondary accent
    readonly property color highlightBg: Qt.rgba(base0E.r, base0E.g, base0E.b, 0.15) // Transparent accent
    readonly property color errorColor: base08    // Error text/icons
    readonly property color greenColor: base0B    // Success indicators
    readonly property color redColor: base08      // Warning/error indicators

    // Theme switching property with persistence
    property bool isDarkTheme: true
    property bool isInitialLoad: true

    // Settings file handling
    FileView {
        id: settingsFile
        path: "root:/Data/settings.json"
        blockWrites: true  // Make writes synchronous
        atomicWrites: true // Ensure file writes are atomic
        watchChanges: false // Disable file watching since we manage state directly
        
        onLoaded: {
            try {
                var content = JSON.parse(text())
                if (content && content.isDarkTheme !== undefined) {
                    isInitialLoad = true
                    colors.isDarkTheme = content.isDarkTheme
                    isInitialLoad = false
                }
            } catch (e) {
                console.log("Error parsing settings:", e)
                isInitialLoad = false
            }
        }
        onSaveFailed: function(error) {
            console.log("Failed to save settings:", error)
        }
    }

    // Helper functions
    function withOpacity(color, opacity) {
        return Qt.rgba(color.r, color.g, color.b, opacity)
    }

    function withHighlight(color) {
        return Qt.rgba(color.r, color.g, color.b, 0.15)
    }

    // Theme switching function with persistence
    function toggleTheme() {
        isDarkTheme = !isDarkTheme
        if (!isInitialLoad) {
            saveSettings()
        }
    }

    // Save settings to file
    function saveSettings() {
        try {
            var jsonContent = JSON.stringify({ isDarkTheme: isDarkTheme }, null, 4)
            settingsFile.setText(jsonContent)
        } catch (e) {
            console.log("Error saving settings:", e)
        }
    }

    // Load settings on startup
    Component.onCompleted: {
        settingsFile.reload()
    }
}
