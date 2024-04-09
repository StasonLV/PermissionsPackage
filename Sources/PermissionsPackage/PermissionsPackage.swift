// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import UIKit

open class Permission {
    
    open var authorized: Bool {
        return status == .authorized
    }
    
    open var denied: Bool {
        return status == .denied
    }
    
    open var notDetermined: Bool {
        return status == .notDetermined
    }
    
    open var debugName: String {
        return kind.name
    }
    

    @available(iOSApplicationExtension, unavailable)
    public static func openAlertSettingPage(for kind: Permission.Kind) {
        let alertDescription: String = switch kind {
        case .camera:
            "Для проведения аудио и видео консультаций с врачом необходимо предоставить доступ к камере."
        case .microphone:
            "Для проведения аудио и видео консультаций с врачом необходимо предоставить доступ к микрофону."
        case .notification:
            "Для получения увдомлений и звонков о начале консультации необходимо предоставить доступ на получение уведомлений."
        case .photoLibrary:
            "Для использования этой функции вы должны предоставить разрешение. Хотите перейти в настройки?"
        case .calendar( _):
            "Для использования этой функции вы должны предоставить разрешение. Хотите перейти в настройки?"
        case .contacts:
            "Для использования этой функции вы должны предоставить разрешение. Хотите перейти в настройки?"
        case .reminders:
            "Для использования этой функции вы должны предоставить разрешение. Хотите перейти в настройки?"
        case .speech:
            "Для использования этой функции вы должны предоставить разрешение. Хотите перейти в настройки?"
        case .location( _):
            "Для использования этой функции вы должны предоставить разрешение. Хотите перейти в настройки?"
        case .motion:
            "Для использования этой функции вы должны предоставить разрешение. Хотите перейти в настройки?"
        case .mediaLibrary:
            "Для использования этой функции вы должны предоставить разрешение. Хотите перейти в настройки?"
        case .bluetooth:
            "Для использования этой функции вы должны предоставить разрешение. Хотите перейти в настройки?"
        case .tracking:
            "Для использования этой функции вы должны предоставить разрешение. Хотите перейти в настройки?"
        case .faceID:
            "Для использования этой функции вы должны предоставить разрешение. Хотите перейти в настройки?"
        case .siri:
            "Для использования этой функции вы должны предоставить разрешение. Хотите перейти в настройки?"
        case .health:
            "Для использования этой функции вы должны предоставить разрешение. Хотите перейти в настройки?"
        }
        
        let alertTitle: String = switch kind {
        case .camera:
            "Нет доступа к камере"
        case .notification:
            "Нет доступа к уведомлениям"
        case .photoLibrary:
            "Нет доступа к фото"
        case .microphone:
            "Нет доступа к микрофону"
        default:
            "Не хватает доступов"
        }
        
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: alertTitle, message: alertDescription, preferredStyle: .alert)
                        
            alertController.addAction(UIAlertAction(title: "Предоставить доступ", style: .default, handler: { _ in
                self.openSettingPage()
            }))
            
            alertController.addAction(UIAlertAction(title: "Отмена", style: .destructive, handler: nil))
            
            UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    public static func openSettingPage() {
        DispatchQueue.main.async {
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: nil)
            }
        }
    }
    
    public static func checkMultiplePermissions(for permissions: [Permission], completion: ((Bool) -> Void)? = nil) {
        for permission in permissions {
            switch permission.status {
            case .denied, .notDetermined:
                permission.request { granted in
                    if !granted {
                        completion?(false)
                        self.openAlertSettingPage(for: permission.kind)
                    }
                }
            case .authorized:
                completion?(true)
                return
            case .notSupported:
                return
            }
        }
    }

    // MARK: Ovveride
    
    open var kind: Permission.Kind {
        preconditionFailure("This method must be overridden.")
    }
    
    open var status: Permission.Status {
        preconditionFailure("This method must be overridden.")
    }
    
    open func request(completion: @escaping ()->Void) {
        preconditionFailure("This method must be overridden.")
    }
    
    open func request(completion: ((Bool) -> Void)? = nil) {
        preconditionFailure("This method must be overridden.")
    }
    
    open var canBePresentWithCustomInterface: Bool {
        return true
    }
    
    // MARK: Init
    
    public init() {}
    
    // MARK: Deinit
    
    deinit {}
    
    // MARK: - Models
    
    @objc public enum Status: Int, CustomStringConvertible {
        
        case authorized
        case denied
        case notDetermined
        case notSupported
        
        public var description: String {
            switch self {
            case .authorized: return "authorized"
            case .denied: return "denied"
            case .notDetermined: return "not determined"
            case .notSupported: return "not supported"
            }
        }
    }
    
    public enum Kind {
        
        case camera
        case notification
        case photoLibrary
        case microphone
        case calendar(access: CalendarAccess)
        case contacts
        case reminders
        case speech
        case location(access: LocationAccess)
        case motion
        case mediaLibrary
        case bluetooth
        case tracking
        case faceID
        case siri
        case health
        
        public var name: String {
            switch self {
            case .camera:
                return "Camera"
            case .photoLibrary:
                return "Photo Library"
            case .microphone:
                return "Microphone"
            case .calendar(access: .write):
                return "Calendar Only Write"
            case .calendar(access: .full):
                return "Calendar"
            case .contacts:
                return "Contacts"
            case .reminders:
                return "Reminders"
            case .speech:
                return "Speech"
            case .location(access: .always):
                return "Location Always"
            case .location(access: .whenInUse):
                return "Location When Use"
            case .motion:
                return "Motion"
            case .mediaLibrary:
                return "Media Library"
            case .bluetooth:
                return "Bluetooth"
            case .notification:
                return "Notification"
            case .tracking:
                return "Tracking"
            case .faceID:
                return "FaceID"
            case .siri:
                return "Siri"
            case .health:
                return "Health"
            }
        }
    }
    
    public enum CalendarAccess {
        
        case full
        case write
    }
    
    public enum LocationAccess {
        
        case whenInUse
        case always
    }
}
