import AVFoundation

struct MicrophonePermission {
    
    @MainActor
    static func request(completion: @escaping (PermissionStatus) -> Void) {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted: completion(.authorized)
        case .denied: completion(.denied)
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                completion(granted ? .authorized : .denied)
            }
        @unknown default:
            completion(.notDetermined)
        }
    }
    
    static func status() -> PermissionStatus {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted: return .authorized
        case .denied: return .denied
        case .undetermined: return .notDetermined
        @unknown default: return .notDetermined
        }
    }
}
