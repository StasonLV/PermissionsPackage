# PermissionsPackage

Унифицированный API для запросов разрешений и получения статусов разрешений на устройстве.

<p float="left">
    <img src="https://github.com/StasonLV/PermissionsPackage/assets/98527464/7aa48fa0-4529-458f-a187-fb9107bbf9ef" width="40">
    <img src="https://github.com/StasonLV/PermissionsPackage/assets/98527464/63916552-441c-49dd-8295-f11a4dd85770" width="40">
    <img src="https://github.com/StasonLV/PermissionsPackage/assets/98527464/99a8791e-b13d-4d6d-ad96-b9c43d256463" width="40">
    <img src="https://github.com/StasonLV/PermissionsPackage/assets/98527464/df6a957f-fe29-4022-944b-c2d7be628b92" width="40">
    <img src="https://github.com/StasonLV/PermissionsPackage/assets/98527464/0d1d47c1-7d04-4b53-b741-bd99536f6274" width="40">
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

> [!WARNING]
> Для использования необходимо добавить в файл `Info.plist` соответствующие пары `[Key : Value]`. Ключи указаны в таблице, описания должны содержать описание задачи для которой будет использоваться то или иное API.

| Иконка |  Permission | Ключ для `Info.plist` | Получение статуса | Запрос разрешение |
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

В Xcode откройте Project -> `Package Dependencies` -> В нижнем левом углу нажмите *Плюс* и введите `url`:

```
https://github.com/StasonLV/PermissionsPackage
```

После того как пакет найден, нажмите `Add Package` в правом нижнем углу и откроется контекстное меню с выбором необходимых разрешений. Выберете из списка.

</details>

## Модульность

> [!NOTE]
> Пакет позволяет раздельный импорт модулей для разных API.

Пакет разбит на отдельные модули под каждый запрашиваемый пермишн. 

Такая реализация вызвана тем, что при импорте единого пакета со всеми запросами Apple review team будет доступна информация о множественном обращении к API пермишенов и при ревью приложения могут задать дополнительные вопросы.
Модуляризированная структура позволяет использовать только те запросы и разрешения, которые необходимы.

## Использование

Импорт модулей

```swift
import PermissionsPackage
import CameraPackage
```

### Запрос разрешений

### Простой запрос без обработки

```swift
import PermissionsPackage
import CameraPackage

    Permission.camera.request()
```

### Запрос разрешения с обработчиком в колбэке

```swift
import PermissionsPackage
import CameraPackage

    Permission.camera.request { granted in
        if granted {
            //Обработка кейса, когда доступ разрешен
        } else {
            //Обработка кейса, когда доступ не разрешен
        }
    }
```

### Проверка статуса разрешений

```swift
import PermissionsPackage
import CameraPackage

    let granted = Permission.notification.authorized
    if granted {

    } else {

    }
```

### Повторный запрос разрешения
Дефолтное поведение системы запрещает многократный вызов нативного запроса пермишенов, поэтому реализован метод повторного запроса. 
В метод передается тип пермишена для актуального наполнения `alert.message`. 

При тапе, пользователя направляет в настройки по `URL` для разрешения доступа к переданному в метод API.

```swift
import PermissionsPackage
import CameraPackage

    @objc private func askCameraPermission() {
        if Permission.camera.status != .authorized {
            Permission.openAlertSettingPage(for: Permission.Kind.camera)
        }
    }
```
