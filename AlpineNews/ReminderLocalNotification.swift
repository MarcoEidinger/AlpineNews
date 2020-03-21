//
//  ReminderLocalNotification.swift
//  AlpineNews
//
//  Created by Eidinger, Marco on 3/21/20.
//  Copyright © 2020 Eidinger, Marco. All rights reserved.
//

import Foundation
import UserNotifications

struct ReminderLocalNotification {
    let reminderNotificationID: String = "Yoo"

    let notificationCenter = UNUserNotificationCenter.current()

    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound]
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }

        notificationCenter.getNotificationSettings { (settings) in
          if settings.authorizationStatus != .authorized {
            // Notifications not allowed
          }
        }
    }

    func scheduleNotification(for date: Date) {

        self.deleteScheduledReminder()

        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "Time to check for news about Swift, iOS and Apple 😀 👍"
        content.sound = UNNotificationSound.default

//        let date = Date()
        let triggerDaily = Calendar.current.dateComponents([.hour,.minute,.second,], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)

//        // show this notification five seconds from now
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: reminderNotificationID, content: content, trigger: trigger)

        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }

    func deleteScheduledReminder() {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [reminderNotificationID])
    }
}
