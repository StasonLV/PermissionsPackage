//
//  File.swift
//  
//
//  Created by Stanislav on 27.03.2024.
//

#if PERMISSIONSPACKAGE_SPM
import PermissionsPackage
#endif

#if os(iOS) && PERMISSIONSPACKAGE_CAMERA
import Foundation
import AVFoundation

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
    
    public override func request(completion: ((Bool) -> Void)? = nil) {
        AVCaptureDevice.requestAccess(for: .video) { finished in
            if let completion = completion {
                DispatchQueue.main.async {
                    completion(finished)
                }
            }
        }
    }
}
#endif
