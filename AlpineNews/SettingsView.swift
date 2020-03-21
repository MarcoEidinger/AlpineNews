//
//  SettingsView.swift
//  AlpineNews
//
//  Created by Eidinger, Marco on 3/21/20.
//  Copyright © 2020 Eidinger, Marco. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var dataModel: DataModel
    @State private var showingAlert: Bool = false
    var body: some View {
        NavigationView {
            Form {
                ReminderSettingsView()
                Section {
                    Button(action: {
                        self.dataModel.reset()
                        self.showingAlert.toggle()
                    }) {
                        HStack {
                            Spacer()
                            Text("Restore")
                            Spacer()
                        }
                    }
                    .multilineTextAlignment(.center)
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Done"))
                    }
                }
            }.navigationBarTitle(Text("Settings"))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
            .previewDisplayName("iPhone SE")
    }
}
