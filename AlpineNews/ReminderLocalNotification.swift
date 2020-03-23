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
                Logger.log(message: "User has declined notifications")
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

        let triggerDaily = Calendar.current.dateComponents([.hour,.minute,.second,], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)

        let request = UNNotificationRequest(identifier: reminderNotificationID, content: content, trigger: trigger)

        notificationCenter.add(request) { (error) in
            if let error = error {
                Logger.log(message: "Error when scheduling reminder \(error.localizedDescription)")
                
                UserDefaults.standard.set(false, forKey: "ReminderScheduled")
                UserDefaults.standard.removeObject(forKey: "ReminderScheduledHour")
                UserDefaults.standard.removeObject(forKey: "ReminderScheduledMinute")
            }
        }

        UserDefaults.standard.set(true, forKey: "ReminderScheduled")
        UserDefaults.standard.set(triggerDaily.hour, forKey: "ReminderScheduledHour")
        UserDefaults.standard.set(triggerDaily.minute, forKey: "ReminderScheduledMinute")
    }

    func deleteScheduledReminder() {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [reminderNotificationID])

        UserDefaults.standard.set(false, forKey: "ReminderScheduled")
        UserDefaults.standard.removeObject(forKey: "ReminderScheduledHour")
        UserDefaults.standard.removeObject(forKey: "ReminderScheduledMinute")
    }

    static func currentReminder() -> (Bool, DateComponents) {
        let isScheduled = UserDefaults.standard.bool(forKey: "ReminderScheduled")

        if isScheduled {
            let hour = UserDefaults.standard.integer(forKey: "ReminderScheduledHour")
            let minute = UserDefaults.standard.integer(forKey: "ReminderScheduledMinute")
            let scheduledDate = Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: Date())!
            let scheduledDateComponents = Calendar.current.dateComponents([.hour,.minute,.second,], from: scheduledDate)
            return (true, scheduledDateComponents)

        } else {
            let defaultDate = Calendar.current.date(bySettingHour: 7, minute: 30, second: 0, of: Date())!
            let defaultDateComponents = Calendar.current.dateComponents([.hour,.minute,.second,], from: defaultDate)
            return (false, defaultDateComponents)
        }
    }
}
