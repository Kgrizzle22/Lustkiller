import FamilyControls
import Foundation
import ManagedSettings

/// Real blocking through Apple's Screen Time APIs: the system adult-website filter,
/// and shields over apps/sites you choose (the shield shows a Bible verse).
@MainActor
final class ScreenTimeManager: ObservableObject {
    @Published private(set) var isAuthorized = AuthorizationCenter.shared.authorizationStatus == .approved
    @Published private(set) var webFilterOn = SharedSettings.webFilterOn
    @Published var selection = FamilyActivitySelection()
    @Published var errorMessage: String?

    private let store = ManagedSettingsStore()

    init() {
        if let data = SharedSettings.appSelectionData,
           let saved = try? JSONDecoder().decode(FamilyActivitySelection.self, from: data) {
            selection = saved
        }
    }

    var shieldedCount: Int {
        selection.applicationTokens.count + selection.categoryTokens.count + selection.webDomainTokens.count
    }

    func requestAuthorization() async {
        do {
            try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
            errorMessage = nil
        } catch {
            errorMessage = "Screen Time permission wasn't granted: \(error.localizedDescription)"
        }
        isAuthorized = AuthorizationCenter.shared.authorizationStatus == .approved
    }

    /// Turns on iOS's built-in adult content filter for Safari and every app that shows web pages.
    func setWebFilter(_ on: Bool) {
        store.webContent.blockedByFilter = on ? .auto() : nil
        SharedSettings.webFilterOn = on
        webFilterOn = on
    }

    func applySelection() {
        store.shield.applications = selection.applicationTokens.isEmpty ? nil : selection.applicationTokens
        store.shield.applicationCategories = selection.categoryTokens.isEmpty ? nil : .specific(selection.categoryTokens)
        store.shield.webDomains = selection.webDomainTokens.isEmpty ? nil : selection.webDomainTokens
        SharedSettings.appSelectionData = try? JSONEncoder().encode(selection)
    }
}
