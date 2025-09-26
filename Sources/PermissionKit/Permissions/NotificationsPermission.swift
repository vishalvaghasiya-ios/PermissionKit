import UserNotifications

struct NotificationsPermission {
    
    @MainActor
    static func request(completion: @escaping (PermissionStatus) -> Void) {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized, .provisional, .ephemeral: completion(.authorized)
            case .denied: completion(.denied)
            case .notDetermined:
                center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                    completion(granted ? .authorized : .denied)
                }
            @unknown default:
                completion(.notDetermined)
            }
        }
    }
    
    static func status() -> PermissionStatus {
        var currentStatus: PermissionStatus = .notDetermined
        let semaphore = DispatchSemaphore(value: 0)
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized, .provisional, .ephemeral: currentStatus = .authorized
            case .denied: currentStatus = .denied
            case .notDetermined: currentStatus = .notDetermined
            @unknown default: currentStatus = .notDetermined
            }
            semaphore.signal()
        }
        semaphore.wait()
        return currentStatus
    }
}
