//
//  Notifications.swift
//  iShnakiOS
//
//  Created by Huw Williams on 13/04/2025.
//

import Foundation
import UserNotifications

class Notifications {
    func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else {
                print("Notification permission denied.")
            }
        }
    }
    func scheduleWaterReminder(every intervalInMin: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Time to Hydrate"
        content.body = "Remember to drink some water!"
        content.sound = .default

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
    func scheduleMealReminder(identifier: String, title: String, meal: Array<Int>) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = "It's time to eat! 🍽️"
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = meal[0]
        dateComponents.minute = meal[1]

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
                print("❌ Failed to schedule \(title) reminder: \(error)")
            }
        }
    }

}
