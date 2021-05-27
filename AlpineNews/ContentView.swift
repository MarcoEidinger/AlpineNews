//
//  ContentView.swift
//  AlpineNews
//
//  Created by Eidinger, Marco on 3/20/20.
//  Copyright © 2020 Eidinger, Marco. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0

    @EnvironmentObject var dataModel: DataModel

    var body: some View {
        TabView(selection: $selection) {
            ResourceListView(category: .news, resources: dataModel.newsResources, dataAPI: dataModel)
                .tabItem {
                    VStack {
                        Image(systemName: "tray")
                        Text(DataModel.title(for: .news))
                    }
                }
                .tag(0)
            ResourceListView(category: .library, resources: dataModel.libaryResources, dataAPI: dataModel)
                .tabItem {
                    VStack {
                        Image(systemName: "book")
                        Text(DataModel.title(for: .library))
                    }
                }
                .tag(1)
            SettingsView().environmentObject(dataModel)
                .tabItem {
                    VStack {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                }
                .tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView().environmentObject(DataModel())

            ContentView()
                .environmentObject(DataModel())
                .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)

            ContentView()
                .environmentObject(DataModel())
                .environment(\.colorScheme, .dark)
        }
        .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
        .previewDisplayName("iPhone SE")
    }
}
