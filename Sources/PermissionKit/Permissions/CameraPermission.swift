import AVFoundation

struct CameraPermission {
    
    @MainActor
    static func request(completion: @escaping (PermissionStatus) -> Void) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized: completion(.authorized)
        case .denied, .restricted: completion(.denied)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { @Sendable granted in
                completion(granted ? .authorized : .denied)
            }
        @unknown default:
            completion(.notDetermined)
        }
    }
    
    static func status() -> PermissionStatus {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized: return .authorized
        case .denied, .restricted: return .denied
        case .notDetermined: return .notDetermined
        @unknown default: return .notDetermined
        }
    }
}
