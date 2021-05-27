//
//  DataModel.swift
//  AlpineNews
//
//  Created by Eidinger, Marco on 3/20/20.
//  Copyright © 2020 Eidinger, Marco. All rights reserved.
//

import Combine
import SwiftUI

private struct FileData: Decodable {
    var categories: CategoriesData
}

private struct CategoriesData: Decodable {
    var news: [Resource]
    var library: [Resource]
}

enum ResourceCategory: String, CaseIterable {
    case news = "news-resourceCategory"
    case library = "library-resourceCategory"
}

protocol DataModelSaveAPI {
    func add(resource: Resource, to category: ResourceCategory)
    func save(_ items: [Resource], for category: ResourceCategory)
}

final class DataModel: ObservableObject, DataModelSaveAPI {
    @Published private(set) var newsResources: [Resource] = [] {
        didSet {
            updateCache(with: newsResources, for: .news)
        }
    }

    @Published private(set) var libaryResources: [Resource] = [] {
        didSet {
            updateCache(with: libaryResources, for: .library)
        }
    }

    @Published private(set) var resources: [ResourceCategory: [Resource]] = [:]

    init() {
        newsResources = loadResources(for: .news)
        libaryResources = loadResources(for: .library)

        for category in ResourceCategory.allCases {
            resources[category] = loadResources(for: category)
        }
    }

    private static func loadBundledResources() -> FileData {
        let url = Bundle.main.url(forResource: "resources", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let decoder = JSONDecoder()
        return try! decoder.decode(FileData.self, from: data)
    }

    static let newsResourcesStatic: [Resource] = DataModel.loadBundledResources().categories.news

    static let libaryResourcesStatic = DataModel.loadBundledResources().categories.library

    static func title(for category: ResourceCategory) -> String {
        switch category {
        case .news:
            return "News"
        case .library:
            return "Libary"
        }
    }

    func loadResources(for category: ResourceCategory) -> [Resource] {
        return (loadResourcesFromDisk(category).isEmpty) ? loadOriginalResources(for: category) : loadResourcesFromDisk(category)
    }

    func reset() {
        newsResources = DataModel.newsResourcesStatic
        libaryResources = DataModel.libaryResourcesStatic

        resources[.news] = newsResources
        resources[.library] = libaryResources

        for category in ResourceCategory.allCases {
            save(resources[category]!, for: category)
        }
    }

    func save(_ items: [Resource], for category: ResourceCategory) {
        switch category {
        case .news:
            newsResources = items
        case .library:
            libaryResources = items
        }

        resources[category] = items
    }

    func add(resource: Resource, to category: ResourceCategory) {
        if libaryResources.count > 0 {
            libaryResources.append(resource)
        } else {
            var resources = loadResources(for: category)
            resources.append(resource)
            save(resources, for: category)
        }
    }

    private func loadOriginalResources(for category: ResourceCategory) -> [Resource] {
        switch category {
        case .news:
            return DataModel.newsResourcesStatic
        case .library:
            return DataModel.libaryResourcesStatic
        }
    }

    private func loadResourcesFromDisk(_ category: ResourceCategory) -> [Resource] {
        do {
            guard let originalData = UserDefaults.standard.data(forKey: category.rawValue) else { return [] }
            let decoder = JSONDecoder()
            return try decoder.decode([Resource].self, from: originalData)
        } catch {
            Logger.log(message: "Unable to load resources from disk (\(error))")
            return []
        }
    }

    private func updateCache(with items: [Resource], for category: ResourceCategory) {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(items)
        UserDefaults.standard.set(data, forKey: category.rawValue)
    }
}

struct Resource: Identifiable, Codable, Hashable {
    var id: String {
        return name
    }

    let name: String
    let url: URL

    var image: Image? {
        if name.contains("lich") {
            return Image("raywenderlich")
        } else if url.absoluteString.contains("swift.org") {
            return Image("swift")
        } else if url.absoluteString.contains("developer.apple.com") {
            return Image("apple")
        } else if url.absoluteString.contains("nshipster.com") {
            return Image("nshipster")
        } else if url.absoluteString.contains("sundell.com") {
            return Image("sundell")
        } else if url.absoluteString.contains("macrumors") {
            return Image("macrumors")
        } else if url.absoluteString.contains("iosdevweekly") {
            return Image("iosdevweekly")
        } else if url.absoluteString.contains("twitter") {
            return Image("twitter")
        } else if url.absoluteString.contains("useyourloaf") {
            return Image("useyourloaf")
        } else if url.absoluteString.contains("hackingwithswift") {
            return Image("hackingwithswift")
        } else if url.absoluteString.contains("github") {
            return Image("github")
        } else {
            return nil
        }
    }
}
