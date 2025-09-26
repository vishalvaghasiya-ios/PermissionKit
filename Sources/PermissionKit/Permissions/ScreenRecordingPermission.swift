import ReplayKit

struct ScreenRecordingPermission {
    static func request(completion: @escaping (PermissionStatus) -> Void) {
        completion(.authorized) // No explicit user permission
    }
    
    static func status() -> PermissionStatus {
        return .authorized
    }
}
