//
//  UserNotificationCenter.swift
//  AlpineNews
//
//  Created by Eidinger, Marco on 4/1/20.
//  Copyright © 2020 Eidinger, Marco. All rights reserved.
//

import Combine
import Foundation
import UIKit
import UserNotifications

class UserNotificationCenter: ObservableObject {
    static let shared = UserNotificationCenter()

    @Published private(set) var notificationsAllowed: Bool = false

    private var nc = UNUserNotificationCenter.current()

    private var cancellables = Set<AnyCancellable>()

    init() {
        NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification,
                                             object: nil)
            .sink { _ in
                self.checkSettings()
            }.store(in: &cancellables)
    }

    func checkSettings() {
        UNUserNotificationCenter.current().getNotificationSettings()
            .flatMap { settings -> AnyPublisher<Bool, Never> in
                switch settings.authorizationStatus {
                case .denied:
                    return Just(false)
                        .eraseToAnyPublisher()
                case .notDetermined:
                    return UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
                        .replaceError(with: false)
                        .eraseToAnyPublisher()
                default:
                    return Just(true)
                        .eraseToAnyPublisher()
                }
            }
            .assign(to: \.notificationsAllowed, on: self)
            .store(in: &cancellables)
    }
}

extension UNUserNotificationCenter {
    func getNotificationSettings() -> Future<UNNotificationSettings, Never> {
        return Future { promise in
            self.getNotificationSettings { settings in
                promise(.success(settings))
            }
        }
    }
}

extension UNUserNotificationCenter {
    func requestAuthorization(options: UNAuthorizationOptions) -> Future<Bool, Error> {
        return Future { promise in
            self.requestAuthorization(options: options) { result, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(result))
                }
            }
        }
    }
}
