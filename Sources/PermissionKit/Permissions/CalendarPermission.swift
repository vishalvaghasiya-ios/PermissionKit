import EventKit

struct CalendarPermission {
    
    @MainActor
    static func request(completion: @escaping (PermissionStatus) -> Void) {
        let status = EKEventStore.authorizationStatus(for: .event)
        switch status {
        case .authorized: completion(.authorized)
        case .denied, .restricted: completion(.denied)
        case .notDetermined:
            EKEventStore().requestAccess(to: .event) { granted, _ in
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
        switch EKEventStore.authorizationStatus(for: .event) {
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
