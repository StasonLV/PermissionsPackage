# PermissionsPackage

Унифицированный API для запросов разрешений и получения статусов на устройстве.

<p float="left">
    <img src="https://github.com/StasonLV/PermissionsPackage/assets/98527464/0d1d47c1-7d04-4b53-b741-bd99536f6274" width="40">
    <img src="https://github.com/StasonLV/PermissionsPackage/assets/98527464/63916552-441c-49dd-8295-f11a4dd85770" width="40">
    <img src="https://github.com/StasonLV/PermissionsPackage/assets/98527464/df6a957f-fe29-4022-944b-c2d7be628b92" width="40">
    <img src="https://github.com/StasonLV/PermissionsPackage/assets/98527464/7aa48fa0-4529-458f-a187-fb9107bbf9ef" width="40">
    <img src="https://github.com/StasonLV/PermissionsPackage/assets/98527464/99a8791e-b13d-4d6d-ad96-b9c43d256463" width="40">
    <img src="https://github.com/StasonLV/PermissionsPackage/assets/98527464/617500b5-cd41-471f-b132-5072a089d4f2" width="40">
</p>

## Содержание

- [Реализованные доступы](#реализованные-доступы)
- [Установка](#установка)
    - [Swift Package Manager](#swift-package-manager)
    - [Модульность](#модульность)
- [Использование](#использование)
    - [Запрос разрешений](#запрос-разрешений)
    - [Проверка статуса разрешений](#проверка-статуса-разрешений)

## Реализованные доступы

|      |  Permission | Ключ для `Info.plist` | Получение статуса | Запрос разрешение |
| :--: | :---------- | :------------------- | :--------: | :----------: |
| <img src="https://github.com/StasonLV/PermissionsPackage/assets/98527464/7aa48fa0-4529-458f-a187-fb9107bbf9ef" width="38"> | Notification | | ✅ | ✅ |
| <img src="https://github.com/StasonLV/PermissionsPackage/assets/98527464/63916552-441c-49dd-8295-f11a4dd85770" width="38"> | Camera | NSCameraUsageDescription | ✅ | ✅ |
| <img src="https://github.com/StasonLV/PermissionsPackage/assets/98527464/99a8791e-b13d-4d6d-ad96-b9c43d256463" width="38"> | Microphone | NSMicrophoneUsageDescription | ✅ | ✅ |
| <img src="https://github.com/StasonLV/PermissionsPackage/assets/98527464/0d1d47c1-7d04-4b53-b741-bd99536f6274" width="38"> | FaceID | NSFaceIDUsageDescription | ☑️ | ✅ |
| <img src="https://github.com/StasonLV/PermissionsPackage/assets/98527464/df6a957f-fe29-4022-944b-c2d7be628b92" width="38"> | Photo Library | NSPhotoLibraryUsageDescription, NSPhotoLibraryAddUsageDescription | ✅ | ✅ |
| <img src="https://github.com/StasonLV/PermissionsPackage/assets/98527464/617500b5-cd41-471f-b132-5072a089d4f2" width="38"> | Contacts | NSContactsUsageDescription | ✅ | ✅ |

## Установка

Ready to use on iOS 11+. Supports iOS, tvOS. Working with `UIKit` and `SwiftUI`.

### Swift Package Manager

<details><summary>Установка SPM</summary>

In Xcode go to Project -> Your Project Name -> `Package Dependencies` -> Tap *Plus*. Insert url:

```

https://github.com/StasonLV/PermissionsPackage

```

Next, choose the permissions that you need. But don't add all of them, because apple will reject app.
Or adding it to the `dependencies` of your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/StasonLV/PermissionsPackage", .upToNextMajor(from: "10.0.1"))
]
```

and choose valid targets.

</details>

## Модульность

Если вы поместите весь код в один пакет и скомпилируете его, команда проверки Apple увидит множество вызовов API разрешений и попросит вас объяснить, почему вы действительно нуждаетесь в этих разрешениях. 
Модули позволяют компилировать только те части кода, которые действительно используются.

> [!WARNING]
> Import only the permissions you really need.

## Использование

### Запрос разрешений

```swift
import PermissionsPackage
import NotificationPermission

Permission.notification.request {
    
}
```

### Проверка статуса разрешений

```swift
import PermissionsPackage
import NotificationPermission

let authorized = Permission.notification.authorized
```

> [!WARNING]
> For FaceID permission no way detect if request `.authorized` or `.notDetermined` accurate. Status `.denied` detect well. For now for both states return `.notDetermined`. 


> [!NOTE]
> Do not use the description as the name of the key. Xcode can't build this.
