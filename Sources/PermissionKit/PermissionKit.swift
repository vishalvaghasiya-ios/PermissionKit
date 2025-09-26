import Foundation
import UIKit

public enum AppPermission {
    case camera, photos, locationWhenInUse, locationAlways, notifications
    case contacts, microphone, calendar, reminders, health, mediaLibrary
    case speech, screenRecording, motion, tracking
}

public enum PermissionStatus {
    case authorized, denied, restricted, notDetermined
}

public class PermissionKit {
    
    @MainActor public static func request(_ permission: AppPermission, completion: @escaping (PermissionStatus) -> Void) {
        PermissionManager.shared.request(permission: permission, completion: completion)
    }
    
    @MainActor public static func status(_ permission: AppPermission) -> PermissionStatus {
        return PermissionManager.shared.status(permission: permission)
    }
}
