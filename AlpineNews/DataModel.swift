//
//  DataModel.swift
//  AlpineNews
//
//  Created by Eidinger, Marco on 3/20/20.
//  Copyright © 2020 Eidinger, Marco. All rights reserved.
//

import Combine
import SwiftUI

enum ResourceCategory: String, CaseIterable {
    case news = "news-resourceCategory"
    case libary = "library-resourceCategory"
}

protocol DataModelSaveAPI {
    func add(resource: Resource, to category: ResourceCategory)
    func save(_ items: [Resource], for category: ResourceCategory)
}

final class DataModel: ObservableObject, DataModelSaveAPI {

    @Published private(set) var newsResources: [Resource] = [] {
        didSet {
            self.updateCache(with: newsResources, for: .news)
        }
    }

    @Published private(set) var libaryResources: [Resource] = [] {
        didSet {
            self.updateCache(with: libaryResources, for: .libary)
        }
    }
    @Published private(set) var resources: [ResourceCategory:[Resource]] = [:]
    
    init() {
        newsResources = loadResources(for: .news)
        libaryResources = loadResources(for: .libary)
        
        for category in ResourceCategory.allCases {
            resources[category] = loadResources(for: category)
        }
    }
    
    static let newsResourcesStatic = [
        Resource(name: "Apple Developer - News", url: URL(string: "https://developer.apple.com/news/")!),
        Resource(name: "Apple Developer - Releases", url: URL(string: "https://developer.apple.com/news/releases/")!),
        Resource(name: "Swift.org - Blog", url: URL(string: "https://swift.org/blog/")!),
        Resource(name: "HackingWithSwift", url: URL(string: "https://www.hackingwithswift.com/articles")!),
        Resource(name: "Ray Wenderlich", url: URL(string: "https://www.raywenderlich.com/library?domain_ids%5B%5D=1")!),
        Resource(name: "Swift by Sundell", url: URL(string: "https://www.swiftbysundell.com/latest/")!),
        Resource(name: "Use Your Loaf", url: URL(string: "https://useyourloaf.com/blog/")!),
        Resource(name: "Twitter - SwiftUI", url: URL(string: "https://twitter.com/search?q=swiftui&src=typed_query")!),
        Resource(name: "Mac Rumors", url: URL(string: "https://www.macrumors.com/")!),
        Resource(name: "iOS Dev Weekly", url: URL(string: "https://iosdevweekly.com/")!),
        Resource(name: "NSHipster", url: URL(string: "https://nshipster.com/")!)
    ]
    
    static let libaryResourcesStatic = [
        Resource(name: "All about SwiftUI", url: URL(string: "https://juanpe.github.io/About-SwiftUI/")!),
        Resource(name: "Using Combine", url: URL(string: "https://heckj.github.io/swiftui-notes/")!),
        Resource(name: "Swift Language Guide", url: URL(string: "https://docs.swift.org/swift-book/LanguageGuide/TheBasics.html")!)
    ]
    
    static func title(for category: ResourceCategory) -> String {
        switch category {
        case .news:
            return "News"
        case .libary:
            return "Libary"
        }
    }
    
    func loadResources(for category: ResourceCategory) -> [Resource] {
        return (self.loadResourcesFromDisk(category).isEmpty) ? self.loadOriginalResources(for: category) : self.loadResourcesFromDisk(category)
    }
    
    func reset() {
        newsResources = DataModel.newsResourcesStatic
        libaryResources = DataModel.libaryResourcesStatic
        
        resources[.news] = newsResources
        resources[.libary] = libaryResources
        
        for category in ResourceCategory.allCases {
            save(resources[category]!, for: category)
        }
    }
    
    func save(_ items: [Resource], for category: ResourceCategory) {
        switch category {
        case .news:
            self.newsResources = items
        case .libary:
            self.libaryResources = items
        }

        self.resources[category] = items
    }

    func add(resource: Resource, to category: ResourceCategory) {
        if self.libaryResources.count > 0 {
            self.libaryResources.append(resource)
        } else {
            var resources = self.loadResources(for: category)
            resources.append(resource)
            self.save(resources, for: category)
        }
    }

    private func loadOriginalResources(for category: ResourceCategory) -> [Resource] {
        switch category {
        case .news:
            return DataModel.newsResourcesStatic
        case .libary:
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


