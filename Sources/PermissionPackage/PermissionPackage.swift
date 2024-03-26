// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import AVFoundation
import UIKit
import LocalAuthentication
import Photos

//@available(iOS 11.0, macCatalyst 14.0, *)
public extension Permission {
    
    static var camera: CameraPermission {
        return CameraPermission()
    }
    
}

public class CameraPermission: Permission {
    
    open override var kind: Permission.Kind { .camera }
    open var usageDescriptionKey: String? { "NSCameraUsageDescription" }
    
    public override var status: Permission.Status {
        switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
        case .authorized: return .authorized
        case .denied: return .denied
        case .notDetermined: return .notDetermined
        case .restricted: return .denied
        @unknown default: return .denied
        }
    }
    
    public override func request(completion: @escaping () -> Void) {
        AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { finished in
            if finished {
                DispatchQueue.main.async {
                    completion()
                }
            } else {
                print("Доступ не предоставлен")
            }
        })
    }
}

public extension Permission {
    
    static var microphone: MicrophonePermission {
        return MicrophonePermission()
    }
    
}

public class MicrophonePermission: Permission {
    
    open override var kind: Permission.Kind { .microphone }
    open var usageDescriptionKey: String? { "NSMicrophoneUsageDescription" }
    
    public override var status: Permission.Status {
        switch  AVAudioSession.sharedInstance().recordPermission {
        case .granted: return .authorized
        case .denied: return .denied
        case .undetermined: return .notDetermined
        @unknown default: return .denied
        }
    }
    
    public override func request(completion: @escaping () -> Void) {
        AVAudioSession.sharedInstance().requestRecordPermission {
            granted in
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}

public extension Permission {
    
    static var faceID: FaceIDPermission {
        return FaceIDPermission()
    }
}

public class FaceIDPermission: Permission {
    
    open override var kind: Permission.Kind { .faceID }
    open var usageDescriptionKey: String? { "NSFaceIDUsageDescription" }
    
    public override var status: Permission.Status {
        let context = LAContext()
        
        var error: NSError?
        let isReady = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        
        guard context.biometryType == .faceID else {
            return .notSupported
        }
        
        switch error?.code {
        case nil where isReady:
            return .notDetermined
        case LAError.biometryNotAvailable.rawValue:
            return .denied
        case LAError.biometryNotEnrolled.rawValue:
            return .notSupported
        default:
            return .notSupported
        }
    }
    
    public override func request(completion: @escaping () -> Void) {
        LAContext().evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: " ") { _, _ in
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}

public extension Permission {
    
    static var notification: NotificationPermission {
        return NotificationPermission()
    }
}

public class NotificationPermission: Permission {
    
    open override var kind: Permission.Kind { .notification }
    
    public override var status: Permission.Status {
        guard let authorizationStatus = fetchAuthorizationStatus() else { return .notDetermined }
        switch authorizationStatus {
        case .authorized: return .authorized
        case .denied: return .denied
        case .notDetermined: return .notDetermined
        case .provisional: return .authorized
        case .ephemeral: return .authorized
        @unknown default: return .denied
        }
    }
    
    private func fetchAuthorizationStatus() -> UNAuthorizationStatus? {
        var notificationSettings: UNNotificationSettings?
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().async {
            UNUserNotificationCenter.current().getNotificationSettings { setttings in
                notificationSettings = setttings
                semaphore.signal()
            }
        }
        semaphore.wait()
        return notificationSettings?.authorizationStatus
    }
    
    public override func request(completion: @escaping () -> Void) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}

public extension Permission {
    
    static var photoLibrary: PhotoLibraryPermission {
        return PhotoLibraryPermission()
    }
}

public class PhotoLibraryPermission: Permission {
    
    open override var kind: Permission.Kind { .photoLibrary }
    
    open var fullAccessUsageDescriptionKey: String? {
        "NSPhotoLibraryUsageDescription"
    }
    
    open var addingOnlyUsageDescriptionKey: String? {
        "NSPhotoLibraryAddUsageDescription"
    }
    
    public override var status: Permission.Status {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized: return .authorized
        case .denied: return .denied
        case .notDetermined: return .notDetermined
        case .restricted: return .denied
        case .limited: return .authorized
        @unknown default: return .denied
        }
    }
    
    public override func request(completion: @escaping () -> Void) {
        PHPhotoLibrary.requestAuthorization({
            finished in
            DispatchQueue.main.async {
                completion()
            }
        })
    }
}


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
    
    
    /**
     PermissionsKit: Open settings page.
     For most permissions its app page in settings app.
     You can overide it if your permission need open custom page.
     */
    @available(iOSApplicationExtension, unavailable)
    public static func openSettingPage() {
        DispatchQueue.main.async {
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: nil)
            }
        }
    }
    
    // MARK: Must Ovveride
    
    open var kind: Permission.Kind {
        preconditionFailure("This method must be overridden.")
    }
    
    open var status: Permission.Status {
        preconditionFailure("This method must be overridden.")
    }
    
    open func request(completion: @escaping ()->Void) {
        preconditionFailure("This method must be overridden.")
    }
    
    open var canBePresentWithCustomInterface: Bool {
        return true
    }
    
    // MARK: Internal
    
    public init() {}
    
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
