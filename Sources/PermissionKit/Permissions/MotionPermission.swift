import CoreMotion
@MainActor
struct MotionPermission {
    
    static var cachedStatus: PermissionStatus = .notDetermined
    
    static func request(motionManager: CMMotionActivityManager, completion: @escaping (PermissionStatus) -> Void) {
        if !CMMotionActivityManager.isActivityAvailable() {
            cachedStatus = .denied
            completion(.denied)
            return
        }
        
        motionManager.queryActivityStarting(from: Date(), to: Date(), to: .main) { (_, error) in
            if let _ = error {
                cachedStatus = .denied
                completion(.denied)
            } else {
                cachedStatus = .authorized
                completion(.authorized)
            }
        }
    }
    
    static func status() -> PermissionStatus {
        if cachedStatus != .notDetermined {
            return cachedStatus
        }

        if !CMMotionActivityManager.isActivityAvailable() {
            cachedStatus = .denied
            return .denied
        }

        let manager = CMMotionActivityManager()
        var result: PermissionStatus = .notDetermined
        let group = DispatchGroup()
        group.enter()

        manager.queryActivityStarting(from: Date(), to: Date(), to: .main) { (_, error) in
            if let _ = error {
                result = .denied
            } else {
                result = .authorized
            }
            cachedStatus = result
            group.leave()
        }

        group.wait()
        return result
    }
}
