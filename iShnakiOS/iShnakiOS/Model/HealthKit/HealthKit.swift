import Foundation
import HealthKit

@MainActor // Ensures all code in this class runs on the main thread (avoids needing [weak self])
class HealthKitManager: ObservableObject {
    
    // MARK: - Properties
    
    private let healthStore = HKHealthStore() // HealthKit store instance
    
    // Published properties to reflect the latest health data in the UI
    @Published var todayStepCount: Int = 0
    @Published var todayStairsCount: TimeInterval = 0
    @Published var todayDistanceWalking: Int = 0
    
    // MARK: - Init
    
    init() {
        requestAuthorization() // Request access to HealthKit on init
    }
    
    // MARK: - Authorization
    
    /// Requests read authorization for the desired HealthKit data types
    private func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        
        // Define the HealthKit quantity types to read (e.g StepCount, KM Walked)
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let exerciseType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
        let stairs = HKQuantityType.quantityType(forIdentifier: .flightsClimbed)!
        
        let readTypes: Set = [stepType, exerciseType, stairs]
        
        // Perform HealthKit authorization request
        Task {
            do {
                try await healthStore.requestAuthorization(toShare: [], read: readTypes)
                
                // Fetch initial values after authorization
                fetchQuantityToday(for: .stepCount, unit: .count()) { value in
                    self.todayStepCount = Int(value)
                }
                
                fetchQuantityToday(for: .flightsClimbed, unit: .count()) { value in
                    self.todayStairsCount = value
                }
                
                fetchQuantityToday(for: .distanceWalkingRunning, unit: .meter()) { value in
                    self.todayDistanceWalking = Int(value)
                }
                
            } catch {
                print("Failed to authorize HealthKit: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Data Fetching
    
    /// Fetches cumulative quantity for today for the given HealthKit identifier and unit
    func fetchQuantityToday(
        for identifier: HKQuantityTypeIdentifier,
        unit: HKUnit,
        resultHandler: @escaping (Double) -> Void
    ) {
        // Get the quantity type from the identifier
        guard let quantityType = HKQuantityType.quantityType(forIdentifier: identifier) else {
            print("Invalid quantity type: \(identifier)")
            return
        }

        // Define start and end times (today's date)
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(
            withStart: startOfDay,
            end: Date(),
            options: .strictStartDate
        )

        // Create a statistics query for the cumulative sum
        let query = HKStatisticsQuery(
            quantityType: quantityType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) { _, result, error in
            DispatchQueue.main.async {
                guard let quantity = result?.sumQuantity(), error == nil else {
                    print("Error fetching \(identifier.rawValue): \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                let value = quantity.doubleValue(for: unit)
                resultHandler(value)
            }
        }

        // Execute the query
        healthStore.execute(query)
    }
    
}
