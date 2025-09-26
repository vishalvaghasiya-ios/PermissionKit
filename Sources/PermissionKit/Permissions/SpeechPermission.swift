import Speech

struct SpeechPermission {
    
    @MainActor
    static func request(completion: @escaping (PermissionStatus) -> Void) {
        let status = SFSpeechRecognizer.authorizationStatus()
        switch status {
        case .authorized: completion(.authorized)
        case .denied, .restricted: completion(.denied)
        case .notDetermined:
            SFSpeechRecognizer.requestAuthorization { newStatus in
                switch newStatus {
                case .authorized: completion(.authorized)
                case .denied, .restricted: completion(.denied)
                case .notDetermined: completion(.notDetermined)
                @unknown default: completion(.notDetermined)
                }
            }
        @unknown default: completion(.notDetermined)
        }
    }
    
    static func status() -> PermissionStatus {
        switch SFSpeechRecognizer.authorizationStatus() {
        case .authorized: return .authorized
        case .denied, .restricted: return .denied
        case .notDetermined: return .notDetermined
        @unknown default: return .notDetermined
        }
    }
}
