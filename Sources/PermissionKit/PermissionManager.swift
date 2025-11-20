import Foundation
import AVFoundation
import Photos
import CoreLocation
import CoreMotion
import UserNotifications
import AppTrackingTransparency

final class PermissionManager: NSObject {
    
    @MainActor static let shared = PermissionManager()
    
    private let locationManager = CLLocationManager()
    private let motionManager = CMMotionActivityManager()
    
    private override init() {
        super.init()
        locationManager.delegate = self
    }
    
    // Store completion handler for location permissions
    private var locationCompletion: ((PermissionStatus) -> Void)?

    @MainActor func request(permission: AppPermission, completion: @escaping (PermissionStatus) -> Void) {
        switch permission {
        case .camera:
            CameraPermission.request(completion: completion)
        case .photos:
            PhotosPermission.request(completion: completion)
        case .locationWhenInUse:
            locationCompletion = completion
            LocationPermission.request(.whenInUse, locationManager: locationManager) { [weak self] status in
                // If status is not .notDetermined, call completion immediately, else wait for delegate
                if status != .notDetermined {
                    self?.locationCompletion?(status)
                    self?.locationCompletion = nil
                }
                // Otherwise, wait for delegate callback
            }
        case .locationAlways:
            locationCompletion = completion
            LocationPermission.request(.always, locationManager: locationManager) { [weak self] status in
                if status != .notDetermined {
                    self?.locationCompletion?(status)
                    self?.locationCompletion = nil
                }
            }
        case .motion:
            MotionPermission.request(motionManager: motionManager, completion: completion)
        case .tracking:
            TrackingPermission.request(completion: completion)
        case .notifications:
            NotificationPermission.request(completion: completion)
        case .microphone:
            MicrophonePermission.request(completion: completion)
        case .contacts:
            ContactsPermission.request(completion: completion)
        case .calendar:
            CalendarPermission.request(completion: completion)
        case .reminders:
            RemindersPermission.request(completion: completion)
        case .speech:
            SpeechPermission.request(completion: completion)
        case .screenRecording:
            ScreenRecordingPermission.request(completion: completion)
        case .health:
            HealthPermission.request(completion: completion)
        case .mediaLibrary:
            MediaLibraryPermission.request(completion: completion)
        // TODO: Add other permissions similarly
        default:
            completion(.notDetermined)
        }
    }
    
    @MainActor func status(permission: AppPermission) -> PermissionStatus {
        switch permission {
        case .camera:
            return CameraPermission.status()
        case .photos:
            return PhotosPermission.status()
        case .locationWhenInUse:
            return LocationPermission.status(.whenInUse)
        case .locationAlways:
            return LocationPermission.status(.always)
        case .motion:
            return MotionPermission.status()
        case .tracking:
            return TrackingPermission.status()
        case .notifications:
            return NotificationPermission.status()
        case .microphone:
            return MicrophonePermission.status()
        case .contacts:
            return ContactsPermission.status()
        case .calendar:
            return CalendarPermission.status()
        case .reminders:
            return RemindersPermission.status()
        case .speech:
            return SpeechPermission.status()
        case .screenRecording:
            return ScreenRecordingPermission.status()
        case .health:
            return HealthPermission.status()
        case .mediaLibrary:
            return MediaLibraryPermission.status()
        default:
            return .notDetermined
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension PermissionManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // Call completion handler if set
        guard let completion = locationCompletion else { return }
        let status = LocationPermission.status(.whenInUse)
        completion(status)
        locationCompletion = nil
    }
}
