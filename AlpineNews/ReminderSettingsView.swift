//
//  ReminderSettingsView.swift
//  AlpineNews
//
//  Created by Eidinger, Marco on 3/21/20.
//  Copyright © 2020 Eidinger, Marco. All rights reserved.
//

import SwiftUI

struct ReminderSettingsView: View {

    @ObservedObject var reminderApi: ReminderLocalNotification

    @ObservedObject private var userNotification = UserNotificationCenter.shared

    @State var selectedDate = Calendar.current.date(bySettingHour: 7, minute: 30, second: 0, of: Date())!

    var dateClosedRange: ClosedRange<Date> {
        let min = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let max = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        return min...max
    }

    private var dateProxy:Binding<Date> {
        Binding<Date>(
            get: {
                self.selectedDate

        },
            set: {
                self.selectedDate = $0
                self.reminderApi.scheduleNotification(for: self.selectedDate)
        }
        )
    }

    var body: some View {
        Section(header: Text((userNotification.notificationsAllowed) ? "Reminder" : "Reminder (allow notifications in iOS settings to be able to schedule a reminder!)")) {
            Toggle(isOn: $reminderApi.currentReminderExists) {
                Text("Remind me to read the news")
            }
            .onTapGesture {
                let isReminderOn = !self.reminderApi.currentReminderExists
                if isReminderOn {
                    self.reminderApi
                        .scheduleNotification(for: self.selectedDate)
                } else {
                    self.reminderApi.deleteScheduledReminder()
                }
            }
            .disabled(!userNotification.notificationsAllowed)
            if self.reminderApi.currentReminderExists == true {
                DatePicker(
                    selection: dateProxy,
                    in: dateClosedRange,
                    displayedComponents: .hourAndMinute,
                    label: { Text("Time to remind") }
                )
            }
        }
        .onAppear() {
            guard let scheduledReminderDate = self.reminderApi.scheduledReminderDate else {
                return
            }
            self.selectedDate = scheduledReminderDate
        }
    }
}

struct ReminderSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ReminderSettingsView(reminderApi: ReminderLocalNotification())
            .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
            .previewDisplayName("iPhone SE")
    }
}
