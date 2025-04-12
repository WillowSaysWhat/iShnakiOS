import Foundation
import HealthKit

@MainActor // this is to prevent the [waek self] warning. this will now run on the main thread.
class HealthKitManager: ObservableObject {
    
    private let healthStore = HKHealthStore()
    
    @Published var todayStepCount: Int = 0
    @Published var todayStairsCount: TimeInterval = 0
    @Published var todayDistanceWalking: Int = 0
    
    init() {
        requestAuthorization()
    }
    
    private func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let exerciseType = HKQuantityType.quantityType(forIdentifier: .appleExerciseTime)!
        let stairs = HKQuantityType.quantityType(forIdentifier: .flightsClimbed)!
        let readTypes: Set = [stepType, exerciseType, stairs]
        
        Task {
            do {
                try await healthStore.requestAuthorization(toShare: [], read: readTypes)
                
                // call for the function below. Asked Chat Jipperty to refactor.
                fetchQuantityToday(for: .stepCount, unit: .count()) {
                    value in self.todayStepCount = Int(value)
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
    
    func fetchQuantityToday(for identifier: HKQuantityTypeIdentifier,unit: HKUnit, resultHandler: @escaping (Double) -> Void) {
        guard let quantityType = HKQuantityType.quantityType(forIdentifier: identifier) else {
            print("Invalid quantity type: \(identifier)")
            return
        }

        let startOfDay = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(
            withStart: startOfDay,
            end: Date(),
            options: .strictStartDate
        )

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

        healthStore.execute(query)
    }

    
}
