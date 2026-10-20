import ReplayKit
import SwiftUI

/// Apple's system button for starting a screen broadcast, pre-set to LustKiller Guard.
/// Apps aren't allowed to start a broadcast themselves; the user has to tap this
/// (or use Control Center > Screen Recording, long-press, pick LustKiller Guard).
struct BroadcastPickerView: UIViewRepresentable {
    func makeUIView(context: Context) -> RPSystemBroadcastPickerView {
        let picker = RPSystemBroadcastPickerView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        picker.preferredExtension = SharedSettings.broadcastExtensionBundleID
        picker.showsMicrophoneButton = false
        return picker
    }

    func updateUIView(_ uiView: RPSystemBroadcastPickerView, context: Context) {}
}
