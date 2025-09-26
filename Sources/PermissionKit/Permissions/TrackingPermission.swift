import AppTrackingTransparency
import AdSupport

struct TrackingPermission {
    
    @MainActor
    static func request(completion: @escaping (PermissionStatus) -> Void) {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized: completion(.authorized)
                case .denied, .restricted: completion(.denied)
                case .notDetermined: completion(.notDetermined)
                @unknown default: completion(.notDetermined)
                }
            }
        } else {
            completion(.authorized) // pre-iOS14 always authorized
        }
    }
    
    static func status() -> PermissionStatus {
        if #available(iOS 14, *) {
            switch ATTrackingManager.trackingAuthorizationStatus {
            case .authorized: return .authorized
            case .denied, .restricted: return .denied
            case .notDetermined: return .notDetermined
            @unknown default: return .notDetermined
            }
        } else {
            return .authorized
        }
    }
}
