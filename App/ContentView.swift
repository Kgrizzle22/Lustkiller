import FamilyControls
import SensitiveContentAnalysis
import SwiftUI
import UserNotifications

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var screenTime = ScreenTimeManager()
    @ObservedObject private var router = VerseRouter.shared

    @State private var detectorReady = false
    @State private var notificationsAllowed = false
    @State private var guardActive = SharedSettings.guardActive
    @State private var detectionCount = SharedSettings.detectionCount
    @State private var alertStyle = SharedSettings.alertStyle
    @State private var showingAppPicker = false

    var body: some View {
        NavigationStack {
            List {
                verseOfTheDay
                screenGuardSection
                blockingSection
                accountabilitySection
            }
            .navigationTitle("LustKiller")
            .familyActivityPicker(isPresented: $showingAppPicker, selection: $screenTime.selection)
            .onChange(of: screenTime.selection) { _, _ in screenTime.applySelection() }
            .onChange(of: alertStyle) { _, style in SharedSettings.alertStyle = style }
            .onChange(of: scenePhase) { _, phase in if phase == .active { refresh() } }
            .task { refresh() }
            .sheet(item: $router.tappedVerse) { verse in
                VerseSheet(verse: verse)
            }
        }
    }

    // MARK: - Sections

    private var verseOfTheDay: some View {
        Section("Who you are in Christ") {
            let verse = Verses.ofTheDay()
            VStack(alignment: .leading, spacing: 8) {
                Text(verse.identity).font(.title3.bold())
                Text(verse.text).font(.body.italic())
                Text(verse.reference).font(.footnote.bold()).foregroundStyle(.secondary)
            }
            .padding(.vertical, 4)
        }
    }

    private var screenGuardSection: some View {
        Section {
            StepRow(done: detectorReady,
                    title: "1. Turn on Sensitive Content Warning",
                    detail: "Settings \u{203A} Privacy & Security \u{203A} Sensitive Content Warning. This switches on Apple's nudity detector, which runs on your phone.") {
                Button("Open Settings") { openSettings() }
            }

            StepRow(done: notificationsAllowed,
                    title: "2. Allow verse notifications",
                    detail: "Verses arrive as Time Sensitive banners, so they show up even when Focus is on.") {
                Button("Allow") { Task { await requestNotifications() } }
            }

            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: guardActive ? "checkmark.shield.fill" : "shield.slash")
                        .foregroundStyle(guardActive ? .green : .secondary)
                    Text(guardActive ? "Screen Guard is ON" : "3. Start Screen Guard").font(.headline)
                    Spacer()
                    BroadcastPickerView().frame(width: 50, height: 50)
                }
                Text("Tap the round button, choose LustKiller Guard, then Start Broadcast. You can also start it from Control Center: long-press Screen Recording and choose LustKiller Guard. A red pill at the top of the screen means it's watching.")
                    .font(.footnote).foregroundStyle(.secondary)
            }
            .padding(.vertical, 4)

            Picker("When nudity is detected", selection: $alertStyle) {
                ForEach(AlertStyle.allCases) { Text($0.label).tag($0) }
            }
        } header: {
            Text("Screen Guard")
        } footer: {
            Text("While Screen Guard is on, it checks your screen about once a second. If it sees nudity, a Bible verse pops up. Screen images are never saved or sent anywhere.")
        }
    }

    private var blockingSection: some View {
        Section {
            if screenTime.isAuthorized {
                Toggle("Block adult websites", isOn: Binding(
                    get: { screenTime.webFilterOn },
                    set: { screenTime.setWebFilter($0) }
                ))
                Button {
                    showingAppPicker = true
                } label: {
                    HStack {
                        Text("Choose apps & sites to block")
                        Spacer()
                        Text("\(screenTime.shieldedCount) chosen").foregroundStyle(.secondary)
                    }
                }
            } else {
                Button("Turn on Screen Time blocking") {
                    Task { await screenTime.requestAuthorization() }
                }
            }
            if let error = screenTime.errorMessage {
                Text(error).font(.footnote).foregroundStyle(.red)
            }
        } header: {
            Text("Always-on blocking")
        } footer: {
            Text("This works all the time, even when Screen Guard is off. Blocked apps show a Bible verse instead of opening.")
        }
    }

    private var accountabilitySection: some View {
        Section {
            LabeledContent("Times a verse appeared", value: "\(detectionCount)")
            if let last = SharedSettings.lastDetection {
                LabeledContent("Last time", value: last.formatted(date: .abbreviated, time: .shortened))
            }
        } header: {
            Text("Accountability")
        } footer: {
            Text("For the strongest protection, also turn on Settings \u{203A} Screen Time \u{203A} Content & Privacy Restrictions \u{203A} App Store, Media, Web & Games \u{203A} Web Content \u{203A} Limit Adult Websites, and let an accountability partner set the Screen Time passcode.")
        }
    }

    // MARK: - Actions

    private func refresh() {
        detectorReady = SCSensitivityAnalyzer().analysisPolicy != .disabled
        guardActive = SharedSettings.guardActive
        detectionCount = SharedSettings.detectionCount
        Task {
            let settings = await UNUserNotificationCenter.current().notificationSettings()
            notificationsAllowed = settings.authorizationStatus == .authorized
        }
    }

    private func requestNotifications() async {
        let granted = (try? await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])) ?? false
        if !granted { openSettings() }
        refresh()
    }

    private func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}

private struct StepRow<Action: View>: View {
    let done: Bool
    let title: String
    let detail: String
    @ViewBuilder let action: () -> Action

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: done ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(done ? .green : .secondary)
                Text(title).font(.headline)
                Spacer()
                if !done { action() }
            }
            if !done {
                Text(detail).font(.footnote).foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

private struct VerseSheet: View {
    let verse: Verse
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: "book.closed.fill").font(.system(size: 48)).foregroundStyle(.tint)
            Text(verse.identity).font(.largeTitle.bold()).multilineTextAlignment(.center)
            Text(verse.text).font(.title2.italic()).multilineTextAlignment(.center)
            Text(verse.reference).font(.headline).foregroundStyle(.secondary)
            Spacer()
            Button("Amen") { dismiss() }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
        }
        .padding(32)
    }
}
