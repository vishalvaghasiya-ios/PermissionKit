import HealthKit

struct HealthPermission {
    
    static let healthStore = HKHealthStore()
    
    @MainActor
    static func request(completion: @escaping (PermissionStatus) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(.denied)
            return
        }
        let readTypes = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!])
        let shareTypes = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!])
        
        healthStore.requestAuthorization(toShare: shareTypes, read: readTypes) { success, _ in
            completion(success ? .authorized : .denied)
        }
    }
    
    static func status() -> PermissionStatus {
        // HealthKit does not provide direct global status
        return .notDetermined
    }
}
