//
//  File.swift
//  
//
//  Created by Stanislav on 27.03.2024.
//

#if PERMISSIONSPACKAGE_SPM
import PermissionsPackage
#endif

#if os(iOS) && PERMISSIONSPACKAGE_FACEID
import Foundation
import LocalAuthentication
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
#endif
