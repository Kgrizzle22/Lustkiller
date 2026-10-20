import CoreImage
import ReplayKit
import SensitiveContentAnalysis
import UserNotifications

/// Runs while "LustKiller Guard" screen broadcasting is on. iOS hands it the screen's
/// video frames; about once a second it shrinks one frame and asks Apple's on-device
/// nudity detector (SensitiveContentAnalysis) about it. Nothing leaves the phone.
///
/// Broadcast upload extensions get roughly 50 MB of memory, so frames are scaled down
/// before analysis and only one analysis runs at a time.
final class SampleHandler: RPBroadcastSampleHandler {
    /// Seconds between frame checks.
    private let checkInterval: TimeInterval = 1.0
    /// Minimum seconds between two verse alerts, so you aren't flooded with banners.
    private let alertCooldown: TimeInterval = 15.0
    /// Longest side, in pixels, of the frame handed to the detector.
    private let analysisSize: CGFloat = 640

    private let analyzer = SCSensitivityAnalyzer()
    private let ciContext = CIContext(options: [.cacheIntermediates: false])

    private let lock = NSLock()
    private var lastCheck = Date.distantPast
    private var lastAlert = Date.distantPast
    private var isAnalyzing = false

    override func broadcastStarted(withSetupInfo setupInfo: [String: NSObject]?) {
        guard analyzer.analysisPolicy != .disabled else {
            finish(message: "Screen Guard can't see nudity yet. Turn on Settings \u{203A} Privacy & Security \u{203A} Sensitive Content Warning, then start Screen Guard again.")
            return
        }
        SharedSettings.guardActive = true
    }

    override func broadcastFinished() {
        SharedSettings.guardActive = false
    }

    override func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
        guard sampleBufferType == .video, beginCheckIfDue() else { return }

        guard let image = makeSmallImage(from: sampleBuffer) else {
            endCheck()
            return
        }

        Task {
            defer { self.endCheck() }
            guard let result = try? await analyzer.analyzeImage(image), result.isSensitive else { return }
            self.handleDetection()
        }
    }

    // MARK: - Throttling

    private func beginCheckIfDue() -> Bool {
        lock.lock(); defer { lock.unlock() }
        let now = Date()
        guard !isAnalyzing, now.timeIntervalSince(lastCheck) >= checkInterval else { return false }
        lastCheck = now
        isAnalyzing = true
        return true
    }

    private func endCheck() {
        lock.lock(); defer { lock.unlock() }
        isAnalyzing = false
    }

    private func claimAlert() -> Bool {
        lock.lock(); defer { lock.unlock() }
        let now = Date()
        guard now.timeIntervalSince(lastAlert) >= alertCooldown else { return false }
        lastAlert = now
        return true
    }

    // MARK: - Frames

    /// Turns the frame upright and scales it down. The CGImage is rendered right away,
    /// so ReplayKit can reuse the frame's buffer as soon as this returns.
    private func makeSmallImage(from sampleBuffer: CMSampleBuffer) -> CGImage? {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
        var image = CIImage(cvPixelBuffer: pixelBuffer)

        if let raw = CMGetAttachment(sampleBuffer, key: RPVideoSampleOrientationKey as CFString, attachmentModeOut: nil) as? NSNumber,
           let orientation = CGImagePropertyOrientation(rawValue: raw.uint32Value) {
            image = image.oriented(orientation)
        }

        let longest = max(image.extent.width, image.extent.height)
        if longest > analysisSize {
            let scale = analysisSize / longest
            image = image.transformed(by: CGAffineTransform(scaleX: scale, y: scale))
        }
        return ciContext.createCGImage(image, from: image.extent)
    }

    // MARK: - Showing the verse

    private func handleDetection() {
        guard claimAlert() else { return }
        let verse = Verses.random()
        SharedSettings.recordDetection(verse: verse)

        switch SharedSettings.alertStyle {
        case .banner:
            postVerseNotification(verse)
        case .fullScreen:
            finish(message: "\(verse.identity).\n\n\(verse.formatted)\n\nThat is not who you are. Open LustKiller to start Screen Guard again.")
        }
    }

    private func postVerseNotification(_ verse: Verse) {
        let content = UNMutableNotificationContent()
        content.title = verse.identity
        content.subtitle = verse.reference
        content.body = verse.text
        content.sound = .default
        content.interruptionLevel = .timeSensitive
        content.userInfo = ["verseReference": verse.reference]

        let request = UNNotificationRequest(identifier: "verse-\(UUID().uuidString)", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request)
    }

    /// Ends the broadcast. iOS then shows `message` in a system alert on top of everything.
    private func finish(message: String) {
        SharedSettings.guardActive = false
        let error = NSError(domain: "LustKiller", code: 1, userInfo: [NSLocalizedDescriptionKey: message])
        finishBroadcastWithError(error)
    }
}
