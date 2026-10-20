import Foundation

/// How the Screen Guard shows a verse when it detects nudity.
enum AlertStyle: String, CaseIterable, Identifiable {
    /// A notification banner drops down over whatever you're looking at. Guard keeps running.
    case banner
    /// iOS shows a full-screen system alert with the verse. This ends the broadcast,
    /// so you have to start Screen Guard again afterwards.
    case fullScreen

    var id: String { rawValue }
    var label: String {
        switch self {
        case .banner: return "Banner (keeps watching)"
        case .fullScreen: return "Full-screen alert (stops guard)"
        }
    }
}

/// Settings and stats shared between the app and its extensions through the App Group.
enum SharedSettings {
    static let appGroup = "group.com.gonowministries.lustkiller"
    static let broadcastExtensionBundleID = "com.gonowministries.lustkiller.broadcast"

    private static let defaults = UserDefaults(suiteName: appGroup) ?? .standard

    private enum Key {
        static let alertStyle = "alertStyle"
        static let detectionCount = "detectionCount"
        static let lastDetection = "lastDetection"
        static let guardActive = "guardActive"
        static let lastVerse = "lastVerse"
        static let appSelection = "appSelection"
        static let webFilterOn = "webFilterOn"
    }

    static var alertStyle: AlertStyle {
        get { AlertStyle(rawValue: defaults.string(forKey: Key.alertStyle) ?? "") ?? .banner }
        set { defaults.set(newValue.rawValue, forKey: Key.alertStyle) }
    }

    static var detectionCount: Int {
        get { defaults.integer(forKey: Key.detectionCount) }
        set { defaults.set(newValue, forKey: Key.detectionCount) }
    }

    static var lastDetection: Date? {
        get { defaults.object(forKey: Key.lastDetection) as? Date }
        set { defaults.set(newValue, forKey: Key.lastDetection) }
    }

    static var guardActive: Bool {
        get { defaults.bool(forKey: Key.guardActive) }
        set { defaults.set(newValue, forKey: Key.guardActive) }
    }

    static var lastVerse: Verse? {
        get { defaults.data(forKey: Key.lastVerse).flatMap { try? JSONDecoder().decode(Verse.self, from: $0) } }
        set { defaults.set(newValue.flatMap { try? JSONEncoder().encode($0) }, forKey: Key.lastVerse) }
    }

    static var webFilterOn: Bool {
        get { defaults.bool(forKey: Key.webFilterOn) }
        set { defaults.set(newValue, forKey: Key.webFilterOn) }
    }

    /// Encoded FamilyActivitySelection (the apps/sites chosen to be shielded).
    static var appSelectionData: Data? {
        get { defaults.data(forKey: Key.appSelection) }
        set { defaults.set(newValue, forKey: Key.appSelection) }
    }

    static func recordDetection(verse: Verse) {
        detectionCount += 1
        lastDetection = Date()
        lastVerse = verse
    }
}
