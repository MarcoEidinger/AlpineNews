//
//  ReminderLocalNotification.swift
//  AlpineNews
//
//  Created by Eidinger, Marco on 3/21/20.
//  Copyright © 2020 Eidinger, Marco. All rights reserved.
//

import Foundation
import Combine
import UserNotifications

class ReminderLocalNotification: ObservableObject {
    private let reminderNotificationID: String = "Yoo"

    private let notificationCenter = UNUserNotificationCenter.current()

    @Published var currentReminderExists = false
    @Published var scheduledReminderDate: Date? =  nil

    init() {
        let isScheduled = UserDefaults.standard.bool(forKey: "ReminderScheduled")

        if isScheduled {

            let hour = UserDefaults.standard.integer(forKey: "ReminderScheduledHour")
            let minute = UserDefaults.standard.integer(forKey: "ReminderScheduledMinute")
            let scheduledDate = Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: Date())!

            self.scheduledReminderDate = scheduledDate
            self.currentReminderExists = true
        }
    }

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

            DispatchQueue.main.async {
                self.scheduledReminderDate = date
                self.currentReminderExists = true
            }
        }

        UserDefaults.standard.set(true, forKey: "ReminderScheduled")
        UserDefaults.standard.set(triggerDaily.hour, forKey: "ReminderScheduledHour")
        UserDefaults.standard.set(triggerDaily.minute, forKey: "ReminderScheduledMinute")

        Logger.trackEvent("Reminder scheduled for \(date.debugDescription)")
    }

    func deleteScheduledReminder() {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [reminderNotificationID])

        UserDefaults.standard.set(false, forKey: "ReminderScheduled")
        UserDefaults.standard.removeObject(forKey: "ReminderScheduledHour")
        UserDefaults.standard.removeObject(forKey: "ReminderScheduledMinute")

        currentReminderExists = false
        scheduledReminderDate = nil
    }
}
