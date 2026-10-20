import SwiftUI
import UserNotifications

@main
struct LustKillerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

final class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    /// Show verse banners even when LustKiller itself is open.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        [.banner, .sound, .list]
    }

    /// Tapping a verse banner opens the app with that verse on screen.
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        let reference = response.notification.request.content.userInfo["verseReference"] as? String
        if let verse = Verses.all.first(where: { $0.reference == reference }) {
            await MainActor.run { VerseRouter.shared.tappedVerse = verse }
        }
    }
}

@MainActor
final class VerseRouter: ObservableObject {
    static let shared = VerseRouter()
    @Published var tappedVerse: Verse?
}
