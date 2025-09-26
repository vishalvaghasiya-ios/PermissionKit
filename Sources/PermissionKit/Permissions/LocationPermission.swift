import CoreLocation

enum LocationType {
    case whenInUse
    case always
}

struct LocationPermission {
    
    static func request(_ type: LocationType, locationManager: CLLocationManager, completion: @escaping (PermissionStatus) -> Void) {
        let status: CLAuthorizationStatus
        if #available(iOS 14, *) {
            status = locationManager.authorizationStatus
        } else {
            status = CLLocationManager.authorizationStatus()
        }
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            completion(.authorized)
        case .denied, .restricted:
            completion(.denied)
        case .notDetermined:
            switch type {
            case .whenInUse: locationManager.requestWhenInUseAuthorization()
            case .always: locationManager.requestAlwaysAuthorization()
            }
            // You can use delegate callback to notify completion
        @unknown default:
            completion(.notDetermined)
        }
    }
    
    static func status(_ type: LocationType) -> PermissionStatus {
        let status: CLAuthorizationStatus
        if #available(iOS 14, *) {
            let locationManager = CLLocationManager()
            status = locationManager.authorizationStatus
        } else {
            status = CLLocationManager.authorizationStatus()
        }
        switch status {
        case .authorizedAlways, .authorizedWhenInUse: return .authorized
        case .denied, .restricted: return .denied
        case .notDetermined: return .notDetermined
        @unknown default: return .notDetermined
        }
    }
}
