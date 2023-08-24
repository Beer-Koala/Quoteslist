//
//  UserDefaultsContainer.swift
//  Quoteslist
//
//  Created by Beer Koala on 24.08.2023.
//

import Foundation

class UserDefaultsContainer {

    // MARK: - Subtypes

    private enum UserDefaultsKey: String {
        case selectedWatchlist
    }

    // MARK: - Public propeties

    static var selectedWatchlist: String {
        get {
            return self.defaults.string(forKey: UserDefaultsKey.selectedWatchlist.rawValue) ?? String.empty
        }
        set {
            self.defaults.set(newValue, forKey: UserDefaultsKey.selectedWatchlist.rawValue)
            self.defaults.synchronize()
        }
    }

    // MARK: - Private propeties

    private static var defaults: UserDefaults {
        return UserDefaults.standard
    }
}
