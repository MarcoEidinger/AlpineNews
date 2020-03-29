//
//  AddToLibaryActivity.swift
//  AlpineNews
//
//  Created by Eidinger, Marco on 3/25/20.
//  Copyright © 2020 Eidinger, Marco. All rights reserved.
//

import Foundation
import UIKit

extension UIActivity.ActivityType {
    static let addToAppLibrary =
        UIActivity.ActivityType("us.eidinger.AlpineNews.addToLibrary")
}

struct AddToAppLibraryItem {
    let url: URL
    let title: String?
}

class AddToAppLibraryActivity: UIActivity {
    var saveAPI: DataModelSaveAPI

    init(saveAPI: DataModelSaveAPI) {
        self.saveAPI = saveAPI
        super.init()
    }

    override class var activityCategory: UIActivity.Category {
        return .action
    }

    override var activityType: UIActivity.ActivityType? {
        return .addToAppLibrary
    }

    override var activityTitle: String? {
        return NSLocalizedString("Add to SwiftNews Library", comment: "add to library")
    }

    override var activityImage: UIImage? {
        return UIImage(systemName: "book")
    }

    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        for case is AddToAppLibraryItem in activityItems {
            return true
        }
        for case is URL in activityItems {
            return true
        }

        return false
    }

    var itemToAdd: AddToAppLibraryItem?

    override func prepare(withActivityItems activityItems: [Any]) {
        for case let item as AddToAppLibraryItem in activityItems {
            self.itemToAdd = item
            return
        }
    }

    override func perform() {
        print(self.itemToAdd.debugDescription)
        var resource = Resource(name: self.itemToAdd?.title ?? "Dummy", url: self.itemToAdd!.url)
        saveAPI.add(resource: resource, to: .library)
        self.activityDidFinish(true)
    }
}
