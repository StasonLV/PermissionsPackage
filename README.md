# PermissionsPackage

Унифицированный API для запросов разрешений и получения статусов на устройстве — доступные `.authorized`, `.denied` & `.notDetermined`.
    <img src="(https://github.com/StasonLV/PermissionsPackage/assets/98527464/f78124ea-9808-46c1-9ec7-ad1ddfd12837)" width="38">

<p float="left">
    <img src="https://cdn.sparrowcode.io/github/permissionskit/icons/camera.png" width="38">
    <img src="https://cdn.sparrowcode.io/github/permissionskit/icons/photos.png" width="38">
    <img src="https://cdn.sparrowcode.io/github/permissionskit/icons/notifications.png" width="38">
    <img src="https://cdn.sparrowcode.io/github/permissionskit/icons/location.png" width="38">
    <img src="https://cdn.sparrowcode.io/github/permissionskit/icons/microphone.png" width="38">
    <img src="https://cdn.sparrowcode.io/github/permissionskit/icons/calendar.png" width="38">
    <img src="https://cdn.sparrowcode.io/github/permissionskit/icons/contacts.png" width="38">
    <img src="https://cdn.sparrowcode.io/github/permissionskit/icons/reminders.png" width="38">
    <img src="https://cdn.sparrowcode.io/github/permissionskit/icons/motion.png" width="38">
    <img src="https://cdn.sparrowcode.io/github/permissionskit/icons/music.png" width="38">
    <img src="https://cdn.sparrowcode.io/github/permissionskit/icons/speech.png" width="38">
    <img src="https://cdn.sparrowcode.io/github/permissionskit/icons/bluetooth.png" width="38">
    <img src="https://cdn.sparrowcode.io/github/permissionskit/icons/health.png" width="38">
    <img src="https://cdn.sparrowcode.io/github/permissionskit/icons/tracking.png" width="38">
    <img src="https://cdn.sparrowcode.io/github/permissionskit/icons/faceid.png" width="38">
    <img src="https://cdn.sparrowcode.io/github/permissionskit/icons/siri.png" width="38">
</p>

## Navigate

- [Permissions](#permissions)
- [Installation](#installation)
    - [Swift Package Manager](#swift-package-manager)
    - [Модульность](#модульность)
- [Usage](#request-permission)
    - [Request Permission](#request-permission)
    - [Get Status Permission](#get-status-permission)
- [Apps Using](#apps-using)

### Permissions

| Icon |  Permission | Key for `Info.plist` | Get Status | Make Request |
| :--: | :---------- | :------------------- | :--------: | :----------: |
| <img src="https://cdn.sparrowcode.io/github/permissionskit/icons/bluetooth.png" width="38"> | Bluetooth | NSBluetoothAlwaysUsageDescription, NSBluetoothPeripheralUsageDescription | ✅ | ✅ |
| <img src="https://cdn.sparrowcode.io/github/permissionskit/icons/calendar.png" width="38"> | Calendar | NSCalendarsUsageDescription, NSCalendarsFullAccessUsageDescription, NSCalendarsWriteOnlyAccessUsageDescription | ✅ | ✅ |
| <img src="https://cdn.sparrowcode.io/github/permissionskit/icons/camera.png" width="38"> | Camera | NSCameraUsageDescription | ✅ | ✅ |
| <img src="https://cdn.sparrowcode.io/github/permissionskit/icons/contacts.png" width="38"> | Contacts | NSContactsUsageDescription | ✅ | ✅ |
| <img src="https://cdn.sparrowcode.io/github/permissionskit/icons/faceid.png" width="38"> | FaceID | NSFaceIDUsageDescription | ☑️ | ✅ |
| <img src="https://cdn.sparrowcode.io/github/permissionskit/icons/health.png" width="38"> | Health | NSHealthUpdateUsageDescription, NSHealthShareUsageDescription | ✅ | ✅ |
| <img src="https://cdn.sparrowcode.io/github/permissionskit/icons/location.png" width="38"> | Location | NSLocationAlwaysAndWhenInUseUsageDescription NSLocationWhenInUseUsageDescription | ✅ | ✅ |
| <img src="https://cdn.sparrowcode.io/github/permissionskit/icons/music.png" width="38"> | Media Library | NSAppleMusicUsageDescription | ✅ | ✅ |
| <img src="https://cdn.sparrowcode.io/github/permissionskit/icons/microphone.png" width="38"> | Microphone | NSMicrophoneUsageDescription | ✅ | ✅ |
| <img src="https://cdn.sparrowcode.io/github/permissionskit/icons/motion.png" width="38"> | Motion | NSMotionUsageDescription | ✅ | ✅ |
| <img src="https://cdn.sparrowcode.io/github/permissionskit/icons/notifications.png" width="38"> | Notification | | ✅ | ✅ |
| <img src="https://cdn.sparrowcode.io/github/permissionskit/icons/photos.png" width="38"> | Photo Library | NSPhotoLibraryUsageDescription, NSPhotoLibraryAddUsageDescription | ✅ | ✅ |
| <img src="https://cdn.sparrowcode.io/github/permissionskit/icons/reminders.png" width="38"> | Reminders | NSRemindersUsageDescription, NSRemindersFullAccessUsageDescription | ✅ | ✅ |
| <img src="https://cdn.sparrowcode.io/github/permissionskit/icons/siri.png" width="38"> | Siri | NSSiriUsageDescription | ✅ | ✅ |
| <img src="https://cdn.sparrowcode.io/github/permissionskit/icons/speech.png" width="38"> | Speech Recognizer | NSSpeechRecognitionUsageDescription | ✅ | ✅ |
| <img src="https://cdn.sparrowcode.io/github/permissionskit/icons/tracking.png" width="38"> | Tracking | NSUserTrackingUsageDescription | ✅ | ✅ |

## Installation

Ready to use on iOS 11+. Supports iOS, tvOS. Working with `UIKit` and `SwiftUI`.

### Swift Package Manager

<details><summary>Установка SPM</summary>

In Xcode go to Project -> Your Project Name -> `Package Dependencies` -> Tap *Plus*. Insert url:

```
https://github.com/sparrowcode/PermissionsKit
```

Next, choose the permissions that you need. But don't add all of them, because apple will reject app.
Or adding it to the `dependencies` of your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/sparrowcode/PermissionsKit", .upToNextMajor(from: "10.0.1"))
]
```

and choose valid targets.

</details>

## Модульность

Если вы поместите весь код в один пакет и скомпилируете его, команда проверки Apple увидит множество вызовов API разрешений и попросит вас объяснить, почему вы действительно нуждаетесь в этих разрешениях. 
Модули позволяют компилировать только те части кода, которые действительно используются.

> [!WARNING]
> Import only the permissions you really need.

## Request Permission

```swift
import PermissionsKit
import NotificationPermission

Permission.notification.request {
    
}
```

## Get Status Permission

```swift
import PermissionsKit
import NotificationPermission

let authorized = Permission.notification.authorized
```

> [!WARNING]
> For FaceID permission no way detect if request `.authorized` or `.notDetermined` accurate. Status `.denied` detect well. For now for both states return `.notDetermined`. 

## Keys in `Info.plist`

You need to add some strings to the `Info.plist` file with descriptions per Apple's requirements. You can get a plist of keys for permissions as follows:

```swift
let key = Permission.bluetooth.usageDescriptionKey
```

> [!NOTE]
> Do not use the description as the name of the key. Xcode can't build this.

### Localisation

If you use xliff localization export, keys will be create automatically. If you prefer do the localization file manually, you need to create `InfoPlist.strings`, select languages on the right side menu and add keys as keys in plist-file. See:

```
"NSCameraUsageDescription" = "Here description of usage camera";
```

