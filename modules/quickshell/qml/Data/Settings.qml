pragma Singleton
import Quickshell

Singleton {

    // Panel
    // - avatarSource can be either a local file or a link
    property string avatarSource: "https://cdn.discordapp.com/avatars/158005126638993408/de403b05fd7f74bb17e01a9b066a30fa?size=1024"

    // Weather
    property string weatherLocation: "Dinslaken"

    // System Monitor
    property int cpuRefreshInterval: 5000
    property int ramRefreshInterval: 10000

    // Notification blacklist
    readonly property var ignoredApps: ["some-app", "another-app"]

    // Screen Border
    property real borderWidth: 9
    property real cornerRadius: 20

    // Recording location
    property string videoPath: "~/Videos/"

}