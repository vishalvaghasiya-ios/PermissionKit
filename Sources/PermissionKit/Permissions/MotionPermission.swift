import CoreMotion

struct MotionPermission {
    
    static func request(motionManager: CMMotionActivityManager, completion: @escaping (PermissionStatus) -> Void) {
        if !CMMotionActivityManager.isActivityAvailable() {
            completion(.denied)
            return
        }
        
        motionManager.queryActivityStarting(from: Date(), to: Date(), to: .main) { (_, error) in
            if let _ = error {
                completion(.denied)
            } else {
                completion(.authorized)
            }
        }
    }
    
    static func status() -> PermissionStatus {
        if !CMMotionActivityManager.isActivityAvailable() {
            return .denied
        } else {
            return .authorized // no direct query, assumed authorized if available
        }
    }
}
