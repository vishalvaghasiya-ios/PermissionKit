import Photos

struct PhotosPermission {
    
    @MainActor
    static func request(completion: @escaping (PermissionStatus) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        switch status {
        case .authorized, .limited: completion(.authorized)
        case .denied, .restricted: completion(.denied)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
                switch newStatus {
                case .authorized, .limited: completion(.authorized)
                case .denied, .restricted: completion(.denied)
                case .notDetermined: completion(.notDetermined)
                @unknown default: completion(.notDetermined)
                }
            }
        @unknown default:
            completion(.notDetermined)
        }
    }
    
    static func status() -> PermissionStatus {
        switch PHPhotoLibrary.authorizationStatus(for: .readWrite) {
        case .authorized, .limited: return .authorized
        case .denied, .restricted: return .denied
        case .notDetermined: return .notDetermined
        @unknown default: return .notDetermined
        }
    }
}
