//
//  ReminderSettingsView.swift
//  AlpineNews
//
//  Created by Eidinger, Marco on 3/21/20.
//  Copyright © 2020 Eidinger, Marco. All rights reserved.
//

import SwiftUI

struct ReminderSettingsView: View {

    @State var isReminderOn: Bool = false

    @State var selectedDate = Calendar.current.date(bySettingHour: 7, minute: 30, second: 0, of: Date())!

    var dateClosedRange: ClosedRange<Date> {
        let min = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let max = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        return min...max
    }

    private let reminderApi = ReminderLocalNotification()

    private var dateProxy:Binding<Date> {
          Binding<Date>(get: {self.selectedDate }, set: {
              self.selectedDate = $0
            self.reminderApi.scheduleNotification(for: self.selectedDate)
          })
      }

    var body: some View {
            Section(header: Text("Reminder")) {
                Toggle(isOn: $isReminderOn) {
                    Text("Remind me to read the news")
                }
                .onTapGesture {
                    let isReminderOn = !self.isReminderOn
                    if isReminderOn {
                        self.reminderApi
                        .requestAuthorization()

                        self.reminderApi
                            .scheduleNotification(for: self.selectedDate)
                    } else {
                        self.reminderApi.deleteScheduledReminder()
                    }
                }
                if self.isReminderOn == true {
                    DatePicker(
                        selection: dateProxy,
                        in: dateClosedRange,
                        displayedComponents: .hourAndMinute,
                        label: { Text("Time to remind") }
                    )
                }
            }
    }
}

struct ReminderSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ReminderSettingsView()
            .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
            .previewDisplayName("iPhone SE")
    }
}
