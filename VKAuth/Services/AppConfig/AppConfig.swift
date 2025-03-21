//
//  AppConfig.swift
//  VKAuth
//
//  Created by Vlad on 19.03.25.
//

import Foundation

final class AppConfig {
    static let shared = AppConfig()
    private let userDefaults = UserDefaults.standard
    
    private init() {}
}

// MARK: - Auth Type

extension AppConfig {
    private var authTypeKey: String {
        return "AuthType"
    }
    
    var authType: AuthType? {
        get {
            guard let rawValue = userDefaults.string(forKey: authTypeKey) else {
                return nil
            }
            return AuthType(rawValue: rawValue)
        }
        set {
            userDefaults.set(newValue?.rawValue, forKey: authTypeKey)
        }
    }
}
