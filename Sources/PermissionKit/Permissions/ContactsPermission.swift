import Contacts

struct ContactsPermission {
    
    @MainActor
    static func request(completion: @escaping (PermissionStatus) -> Void) {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        switch status {
        case .authorized: completion(.authorized)
        case .denied, .restricted: completion(.denied)
        case .notDetermined:
            CNContactStore().requestAccess(for: .contacts) { granted, _ in
                completion(granted ? .authorized : .denied)
            }
        case .limited:
            completion(.authorized)
        @unknown default:
            completion(.notDetermined)
        }
    }
    
    static func status() -> PermissionStatus {
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized: return .authorized
        case .denied, .restricted: return .denied
        case .notDetermined: return .notDetermined
        case .limited:
            return .authorized
        @unknown default: return .notDetermined
        }
    }
}
