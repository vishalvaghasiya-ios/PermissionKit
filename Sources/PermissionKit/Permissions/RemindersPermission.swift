import EventKit

struct RemindersPermission {
    
    @MainActor
    static func request(completion: @escaping (PermissionStatus) -> Void) {
        let status = EKEventStore.authorizationStatus(for: .reminder)
        switch status {
        case .authorized: completion(.authorized)
        case .denied, .restricted: completion(.denied)
        case .notDetermined:
            EKEventStore().requestAccess(to: .reminder) { granted, _ in
                completion(granted ? .authorized : .denied)
            }
        case .fullAccess:
            completion(.authorized)
        case .writeOnly:
            completion(.authorized)
        @unknown default:
            completion(.notDetermined)
        }
    }
    
    static func status() -> PermissionStatus {
        switch EKEventStore.authorizationStatus(for: .reminder) {
        case .authorized: return .authorized
        case .denied, .restricted: return .denied
        case .notDetermined: return .notDetermined
        case .fullAccess:
            return .authorized
        case .writeOnly:
            return .authorized
        @unknown default: return .notDetermined
        }
    }
}
