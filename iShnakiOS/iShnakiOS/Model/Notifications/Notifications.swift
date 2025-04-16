//
//  Notifications.swift
//  iShnakiOS
//
//  Created by Huw Williams on 13/04/2025.
//

import Foundation
import UserNotifications

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
