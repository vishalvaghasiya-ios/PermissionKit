import MediaPlayer
import StoreKit

struct MediaLibraryPermission {
    
    @MainActor
    static func request(completion: @escaping (PermissionStatus) -> Void) {
        let status = MPMediaLibrary.authorizationStatus()
        switch status {
        case .authorized: completion(.authorized)
        case .denied, .restricted: completion(.denied)
        case .notDetermined:
            MPMediaLibrary.requestAuthorization { newStatus in
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
        switch MPMediaLibrary.authorizationStatus() {
        case .authorized: return .authorized
        case .denied, .restricted: return .denied
        case .notDetermined: return .notDetermined
        @unknown default: return .notDetermined
        }
    }
}
