# Model

---

## Table of Contents

- [Model](#model)
  - [Table of Contents](#table-of-contents)
  - [Swiftdata Models (Item.swift)](#swiftdata-models-itemswift)
    - [UserData](#userdata)
    - [UserData extension](#userdata-extension)
  - [Default Goals](#default-goals)
  - [User Notifications](#user-notifications)
  - [Notifications](#notifications)
  - [HealthKit Manager](#healthkit-manager)
---

## Swiftdata Models (Item.swift)

SwiftData is Apple’s modern, declarative persistence framework designed to simplify local data storage in SwiftUI apps. In iShnak iOS, SwiftData is used to store user input—such as water intake, meals, snacks, and calorie consumption—alongside default goals and notification settings. Data is modeled using custom structs that conform to the @Model macro, and queries are handled with property wrappers like @Query to automatically fetch and filter records.

When users interact with the app (e.g. logging a meal or drink), the data is saved in real-time to the local SQLite database managed by SwiftData. Updates are persisted using the modelContext environment property, allowing seamless insertions, edits, and deletions. SwiftData ensures the data remains synchronized across the app and available offline, making it a reliable and efficient solution for managing user data in personal tracking apps like iShnak iOS.

### UserData

The UserData model is the central structure used in iShnak iOS to track all daily user input. It conforms to SwiftData’s @Model macro, enabling it to be stored and managed easily within the local database. Each instance of UserData represents a single day’s record and includes fields such as:

* `amountofWater:` milliliters of water consumed

* `amountofBeverage:` other beverages consumed (e.g., coffee, tea)

* `amountofMeal:` number of meals logged

* `amountofSnack:` number of snacks logged

* `caloriesConsumed:` total calories for the day

* `mealCalories`, `snackCalories`, `beverageCalories: calorie breakdowns`

* `date:` a `Date` object representing the day

This model allows the app to separate and track consumption data on a per-day basis, ensuring historical accuracy and personalized trend analysis.

```swift
@Model
final class UserData {
    @Attribute(.unique) var date: Date  // Unique identifier for the day
    
    // Actual consumption and activity metrics
    var caloriesConsumed: Int
    var beverageCalories: Int
    var mealCalories: Int
    var snackCalories: Int
    var stepsTaken: Int
    var amountofWater: Int
    var amountofBeverage: Int
    var amountofSnack: Int
    var amountofMeal: Int
    
    // Default initializer sets all values to zero and uses today’s date
    init() {
        self.date = Calendar.current.startOfDay(for: Date())
        self.caloriesConsumed = 0
        self.beverageCalories = 0
        self.mealCalories = 0
        self.snackCalories = 0
        self.amountofWater = 0
        self.stepsTaken = 0
        self.amountofBeverage = 0
        self.amountofSnack = 0
        self.amountofMeal = 0
    }
}

// Extension for querying only today’s data using a SwiftData predicate
extension UserData {
    static func todayPredicate() -> Predicate<UserData> {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        let startOfTomorrow = calendar.date(byAdding: .day, value: 1, to: startOfToday)!

        return #Predicate<UserData> { data in
            data.date >= startOfToday && data.date < startOfTomorrow
        }
    }
}

```

### UserData extension

The `UserData` extension above provides utility functionality for managing time-based filtering. Specifically, it adds a static function:

```swift 
static func todayPredicate() -> Predicate<UserData> 
```
This function returns a predicate that filters for entries recorded "today", by comparing the `date` property with the start and end of the current day. This is crucial for populating views with only today's data, ensuring real-time logging and preventing multiple entries for a single day. It simplifies SwiftData queries by encapsulating the date logic in one reusable location.

## Default Goals

The `GoalDefaults` model in iShnak iOS defines the user's personalized daily targets for various aspects of their nutrition and hydration. It is annotated with the `@Model` macro, making it compatible with SwiftData for persistent local storage.

```swift
@Model
final class GoalDefaults {
    var calorieGoal: Int
    var mealGoal: Int
    var snackGoal: Int
    var BeverageGoal: Int
    var waterGoal: Int
    var cupSize: Int
    var waterBottleSize: Int
    var beverageSize: Int
    var mealSize: Int
    var snackSize: Int
    var stepGoal: Int

    // Default initializer sets all goals and sizes to 0
    init() {
        calorieGoal = 0                // Daily calorie goal
        waterGoal = 0                  // Water intake goal
        cupSize = 0                    // Size of one cup of water
        mealGoal = 0                   // Meals per day
        snackGoal = 0                  // Snacks per day
        BeverageGoal = 0              // Beverages per day
        waterBottleSize = 0           // Size of water bottle
        beverageSize = 0              // Size of beverage serving
        mealSize = 0                  // Calories per meal
        snackSize = 0                 // Calories per snack
        stepGoal = 0                  // Steps goal (e.g. 10,000 steps)
    }
}
```

Each instance of `GoalDefaults` stores a set of baseline goals that guide how much of each input the user should strive to achieve daily. These values are used across the app to visually calculate progress in activity rings and track performance.

Key properties include:

* waterGoal: Daily water intake target in milliliters

* BeverageGoal: Daily beverage goal (non-water drinks) in milliliters

* `mealGoal:` Expected number of full meals per day (usually 3)

* `snackGoal:` Expected number of snacks (e.g., 2)

* `calorieGoal:` Daily calorie intake target

* `stepGoal:` Step count goal, if the user enables activity tracking

The `GoalDefaults` model is typically initialized during onboarding when the user first sets up the app. It is also editable via the Profile View, allowing users to adjust their goals as needed. These defaults are referenced in multiple views, such as Home, Activity Rings, and Charts, ensuring consistency throughout the app's tracking system.

## User Notifications

The `UserNotificationSettings` model manages all user-specific preferences for scheduling daily reminders within the iShnak iOS app. It is declared as a SwiftData `@Model`, allowing it to be saved and retrieved easily from the local database.

```swift
// Stores the user’s notification preferences
@Model
final class UserNotificationSettings {
    var breakfastHour: Int
    var breakfastMin: Int
    var breakfastBool: Bool

    var lunchHour: Int
    var lunchMin: Int
    var lunchBool: Bool

    var dinnerHour: Int
    var dinnerMin: Int
    var dinnerBool: Bool

    var waterReminder: Int
    var waterReminderBool: Bool

    // Default notification times and toggles
    init () {
        breakfastHour = 8          // 8:00 AM
        breakfastMin = 0
        lunchHour = 13             // 1:30 PM
        lunchMin = 30
        dinnerHour = 18            // 6:00 PM
        dinnerMin = 0
        waterReminder = 120        // Every 2 hours
        breakfastBool = false
        lunchBool = false
        dinnerBool = false
        waterReminderBool = false
    }
}


```

This model is primarily used in the Profile View, where users can enable or disable notifications and customize the time of day they'd like to receive them.

__Key Features:__

* Meal Reminders
    Users can schedule reminders for:
    * breakfastHour / breakfastMin
    * lunchHour / lunchMin
    * dinnerHour / dinnerMin
    These properties store the time, while corresponding booleans (breakfastBool, lunchBool, dinnerBool) determine if each reminder is active.

* Hydration Reminders
    The waterReminder property allows users to set an hourly interval (e.g., every X hours). The waterReminderBool boolean toggles this feature on or off.

These settings are accessed by the app's `Notifications` class, which schedules notifications using Apple’s `UserNotifications` framework. This design ensures a tailored reminder experience that aligns with each user’s daily routine and goals, improving consistency and engagement.

## Notifications

The Notifications class in iShnak iOS is a utility that handles scheduling and managing local notifications for hydration and meal reminders. It leverages Apple’s UserNotifications framework to ensure users are reminded to stay on track with their daily health goals.

__Key Responsibilities:__
* __Requesting Permission__
The static method `requestNotificationPermissions()` asks the user for authorization to send notifications with alerts, sounds, and badges. This should be called during onboarding or when entering the Profile View.

* __Scheduling Water Reminders__
The method `scheduleWaterReminder(every intervalInMin: Int)` sets up a repeating notification based on a specified hourly interval. For example, it can remind users to drink water every 60 minutes.

* __Scheduling Meal Reminders__
The `scheduleMealReminder(identifier:title:mealHour:mealMin:)` method creates a notification for breakfast, lunch, or dinner at a fixed time every day. The identifier is used to manage or remove specific meal notifications.

* __Removing Notifications__
Notifications can also be canceled by their identifier using `UNUserNotificationCenter`.

```swift
// MARK: - Notification Manager
class Notifications {

    /// Requests permission from the user to show notifications
    static func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else {
                print("Notification permission denied.")
            }
        }
    }

    /// Schedules a repeating water reminder notification
    /// - Parameter intervalInMin: Interval in **hours**, not minutes (value will be multiplied by 3600)
    static func scheduleWaterReminder(every intervalInMin: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Time to Hydrate"
        content.body = "Remember to drink some water!"
        content.sound = .default

        // Schedules the reminder based on a time interval (converted to seconds)
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: TimeInterval(intervalInMin * 3600),
            repeats: true
        )

        let request = UNNotificationRequest(
            identifier: "WaterReminder",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule water reminder: \(error)")
            }
        }
    }

    /// Schedules a meal reminder notification at a specific time of day
    /// - Parameters:
    ///   - identifier: Unique ID for the notification
    ///   - title: Title of the notification
    ///   - mealHour: Hour of the reminder (24-hour format)
    ///   - mealMin: Minute of the reminder
    static func scheduleMealReminder(identifier: String, title: String, mealHour: Int, mealMin: Int) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = "It's time to eat! 🍽️"
        content.sound = .default

        // Configure time for daily repeating alert
        var dateComponents = DateComponents()
        dateComponents.hour = mealHour
        dateComponents.minute = mealMin

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents,
            repeats: true
        )

        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                
                print("Failed to schedule \(title) reminder: \(error)")
            }
        }
    }
}

```

__Integration__
This class is triggered from the Profile View, where users configure their preferences. It ensures that all reminders reflect current user settings.

## HealthKit Manager

The `HealthKitManager` class is a dedicated wrapper for interacting with Apple’s `HealthKit` framework. Its role is to securely read the user's health data—specifically steps, distance walked, and flights climbed—and make it available within the app to support activity tracking.

__Key Responsibilities:__

* _Authorization_
When the app is launched or when `HealthKitManager` is initialized, it requests permission from the user to read relevant health data types. These include:
  * Step Count
  * Distance Walked/Run
  * Flights Climbed

* _Reading Daily Data_
The manager calculates totals for the current day using HKStatisticsQuery and makes the results accessible through published properties like `todayStepCount`, `todayDistanceWalking`, and `todayStairsCount`.

* _Real-Time Updates_
Although primarily used for daily totals, the class can be extended to observe real-time updates via `HKObserverQuery` or similar mechanisms if needed.

```swift
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

```

__Integration__
`HealthKitManager` is used as a `@StateObject` in views like `HomeView`, allowing the UI to reflect up-to-date health stats in `DisplayCards` and `ActivityRings`. This helps users visually monitor their movement goals alongside hydration and meals.

