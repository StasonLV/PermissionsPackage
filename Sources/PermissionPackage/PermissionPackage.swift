// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import AVFoundation
import UIKit

//@available(iOS 11.0, macCatalyst 14.0, *)
//public extension Permission {
//    
//    static var camera: CameraPermission {
//        return CameraPermission()
//    }
//}

//@available(iOS 11.0, macCatalyst 14.0, *)
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
        AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: {
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
    open func openSettingPage() {
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
