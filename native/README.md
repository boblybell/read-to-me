# ReadToMe native iPhone app

The native app is the same web app inside a thin iPhone shell (Capacitor).
One native piece, `DocScan`, gives the glass screen Apple's own document finder (Vision).
On the web, the app uses its own finder; in the native app it uses Apple's.

## Needs

- A Mac with Xcode (from the Mac App Store), opened once, terms accepted.
- Xcode > Settings > Accounts: your Apple ID.
- Node.js 20 or newer (`brew install node`, or from nodejs.org).
- The iPhone, a cable, and Developer Mode on the iPhone
  (Settings > Privacy & Security > Developer Mode; it shows after the iPhone is connected to Xcode).

## First setup (one time)

```sh
git clone https://github.com/boblybell/read-to-me.git && cd read-to-me
npm init -y
npm i @capacitor/core@latest @capacitor/ios@latest
npm i -D @capacitor/cli@latest
./scripts/build-www.sh
npx cap add ios
cp native/ios/DocScanPlugin.swift native/ios/MainViewController.swift ios/App/App/
cp native/ios/AppIcon-1024.png ios/App/App/Assets.xcassets/AppIcon.appiconset/AppIcon-512@2x.png
```

Then in Xcode (`npx cap open ios`):

1. Add the two Swift files to the App target (drag them into the App group, tick "App").
2. Main.storyboard: select the Bridge View Controller, set Custom Class to `MainViewController`, module `App`.
3. Info.plist: add
   - `NSCameraUsageDescription` = "ReadToMe uses the camera to see the book page."
   - `NSMicrophoneUsageDescription` = "ReadToMe records family voices for the stickers."
4. Signing & Capabilities: Team = your Apple ID. Bundle ID `com.boblybell.readtome`.
   - `WKAppBoundDomains` (Array) with one item: `boblybell.github.io`
     (lets the app keep working offline, like the Home Screen web app).
5. Deployment target: iOS 15.0 or newer (Apple's document finder needs iOS 15).
6. Choose the iPhone at the top, press Run.

## Update after a change

The app loads its pages live from https://boblybell.github.io/read-to-me/
(`server.url` in capacitor.config.json). A change pushed to GitHub shows on the phone
after you close and open the app. No Mac needed.

Only a change to the native part (files in native/ios, or capacitor.config.json) needs the Mac:
```sh
git pull && ./scripts/build-www.sh && npx cap sync ios
```
Then press Run in Xcode. Do not delete the app on the iPhone: that removes its books and recordings.

## Moving books from the web app

Web app: Settings > Save backup (Save to Files). Native app: Settings > Restore backup.
