import ManagedSettings
import ManagedSettingsUI
import UIKit

/// Replaces Screen Time's default "Restricted" screen with one that shows a Bible verse
/// whenever you open an app or site you chose to shield in LustKiller.
final class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    override func configuration(shielding application: Application) -> ShieldConfiguration {
        verseShield()
    }

    override func configuration(shielding application: Application, in category: ActivityCategory) -> ShieldConfiguration {
        verseShield()
    }

    override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
        verseShield()
    }

    override func configuration(shielding webDomain: WebDomain, in category: ActivityCategory) -> ShieldConfiguration {
        verseShield()
    }

    private func verseShield() -> ShieldConfiguration {
        let verse = Verses.random()
        return ShieldConfiguration(
            backgroundBlurStyle: .systemUltraThinMaterialDark,
            backgroundColor: UIColor(red: 0.08, green: 0.10, blue: 0.20, alpha: 1),
            icon: UIImage(systemName: "book.closed.fill"),
            title: ShieldConfiguration.Label(text: "Blocked by LustKiller", color: .white),
            subtitle: ShieldConfiguration.Label(text: verse.formatted, color: UIColor(white: 0.9, alpha: 1)),
            primaryButtonLabel: ShieldConfiguration.Label(text: "Close", color: .white),
            primaryButtonBackgroundColor: .systemBlue
        )
    }
}
