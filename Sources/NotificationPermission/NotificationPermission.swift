//
//  File.swift
//  
//
//  Created by Stanislav on 27.03.2024.
//

#if PERMISSIONSPACKAGE_SPM
import PermissionsPackage
#endif

#if PERMISSIONSPACKAGE_NOTIFICATION
import UserNotifications

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
    
    public override func request(completion: ((Bool) -> Void)? = nil) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            DispatchQueue.main.async {
                if error == nil {
                    completion?(true)
                } else {
                    completion?(false)
                }
            }
        }
    }
}
#endif
