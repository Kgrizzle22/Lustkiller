# LustKiller

An iPhone app that helps you turn away from pornography. It does two things:

1. **Screen Guard.** While it's on, it checks your screen about once a second with Apple's
   built-in, on-device nudity detector. When it sees nudity, a Bible verse pops up.
2. **Always-on blocking.** Uses Screen Time to turn on iOS's adult-website filter, and lets
   you block whole apps or sites. A blocked app shows a Bible verse instead of opening.

All checking happens on the phone. No screen image is ever saved or sent anywhere.

## What iPhone allows (please read)

Apple does not let any app see what other apps show on the screen, or draw over them, unless
you turn on screen broadcasting. So:

- **Screen Guard only works while the broadcast is on.** You start it yourself, and iOS shows a
  red pill at the top of the screen while it runs. It stops if the phone restarts or iOS ends it
  to save memory, and you have to start it again.
- **The verse shows as a notification banner** that drops over whatever you're looking at. In
  the *Full-screen alert* setting, iOS instead shows a big system alert with the verse. That
  also ends Screen Guard, so you have to start it again.
- **The detector looks for nudity in general.** It doesn't tell men from women. It isn't
  perfect: it will miss some images and occasionally flag a harmless one.
- **The always-on blocking is the strongest part**, because it's enforced by iOS itself and
  keeps working when Screen Guard is off.

For the best protection, also use iOS's own setting: **Settings › Screen Time › Content &
Privacy Restrictions › App Store, Media, Web & Games › Web Content › Limit Adult Websites**,
and have an accountability partner set the Screen Time passcode so you can't switch it off on
a weak night.

## What you need to install it

- A **Mac** with **Xcode 16 or newer** (free from the Mac App Store)
- An **iPhone on iOS 17 or newer**, and a USB cable
- An **Apple Developer account**. The paid one ($99/year) is strongly recommended. With a free
  account, apps stop working after 7 days and must be reinstalled, and the Screen Time
  (Family Controls) feature may not be available.

## Install steps

1. On the Mac, install XcodeGen: `brew install xcodegen` (needs [Homebrew](https://brew.sh)).
2. Download this repository, open Terminal in its folder and run `xcodegen`.
   This creates `LustKiller.xcodeproj`.
3. Open `LustKiller.xcodeproj` in Xcode.
4. For **each** of the three targets (LustKiller, LustKillerBroadcast, LustKillerShield), go to
   **Signing & Capabilities** and choose your Team.
   - If Xcode says a bundle ID or the App Group is taken, change `com.gonowministries` to
     something of your own in `project.yml`, in `Shared/SharedSettings.swift`, and in the
     App Group name, then run `xcodegen` again.
5. Plug in your iPhone, select it at the top of Xcode, and press **Run** (▶).
   The first time, approve the developer on the phone under
   **Settings › General › VPN & Device Management**, and turn on
   **Settings › Privacy & Security › Developer Mode**.

## Setting it up on the phone

1. **Settings › Privacy & Security › Sensitive Content Warning**: turn it on. This switches on
   Apple's nudity detector, which Screen Guard uses.
2. Open LustKiller and tap **Allow** for notifications.
3. Tap the round button next to **Start Screen Guard**, choose **LustKiller Guard**, and tap
   **Start Broadcast**. Faster later: open Control Center, long-press **Screen Recording**, and
   choose LustKiller Guard.
4. Tap **Turn on Screen Time blocking**, then switch on **Block adult websites**, and
   optionally choose apps to block (for example a browser you shouldn't use).

## How the code is laid out

| Folder | What it is |
| --- | --- |
| `App/` | The main app screen: setup steps, settings and the verse of the day |
| `BroadcastExtension/` | Screen Guard: gets screen frames, checks them for nudity, shows a verse |
| `ShieldExtension/` | The Screen Time block screen with a Bible verse |
| `Shared/` | The Bible verses (KJV, public domain) and settings shared between the parts |
| `project.yml` | Recipe XcodeGen uses to build the Xcode project |

To add or change verses, edit `Shared/Verses.swift`.

Tuning values are at the top of `BroadcastExtension/SampleHandler.swift`: how often the screen
is checked (`checkInterval`), and the minimum time between two verse alerts (`alertCooldown`).

## Publishing to the App Store

Installing on your own phone needs none of this. To publish, you'd need to ask Apple for the
**Family Controls (Distribution)** entitlement for the app and the shield extension, which Apple
reviews by hand.
