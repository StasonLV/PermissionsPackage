//
//  File.swift
//  
//
//  Created by Stanislav on 27.03.2024.
//

#if PERMISSIONSPACKAGE_SPM
import PermissionsPackage
#endif

#if os(iOS) && PERMISSIONSPACKAGE_MIC
import Foundation
import AVFoundation

public extension Permission {
    static var microphone: MicPermission {
        return MicPermission()
    }
}

public class MicPermission: Permission {
    
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
#endif
