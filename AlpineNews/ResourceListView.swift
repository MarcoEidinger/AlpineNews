//
//  ResourceListView.swift
//  AlpineNews
//
//  Created by Eidinger, Marco on 3/20/20.
//  Copyright © 2020 Eidinger, Marco. All rights reserved.
//

import SwiftUI

struct ResourceListView: View {
    let category: ResourceCategory
    @Binding var resources: [Resource]
    var saveAPI: DataModelSaveAPI

    private let title: String = "News"
    @State private var selection: Int? = nil
    
    var body: some View {
        NavigationView {
            List {
                ForEach(resources) { item in
                    HStack {
                        if item.image != nil {
                            item.image?.resizable().frame(width: 32, height: 32, alignment: .center).fixedSize()
                        }
                        NavigationLink(item.name, destination: ResourceWebViewer(url: item.url))
                    }
                }
                .onMove(perform: move)
                .onDelete(perform: delete)
            }
            .navigationBarTitle(title)
        }
    }

    func move(from source: IndexSet, to destination: Int) {
        resources.move(fromOffsets: source, toOffset: destination)
        saveAPI.save(resources, for: category)
    }

    func delete(at offsets: IndexSet) {
        resources.remove(atOffsets: offsets)
        saveAPI.save(resources, for: category)
    }
}

struct ResourceListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ResourceListView(category: .news, resources: .constant(DataModel.newsResourcesStatic), saveAPI: DataModel())
              .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
              .previewDisplayName("iPhone SE")

        }
    }
}
