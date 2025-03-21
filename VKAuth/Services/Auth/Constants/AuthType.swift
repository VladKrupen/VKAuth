//
//  AuthType.swift
//  VKAuth
//
//  Created by Vlad on 18.03.25.
//

import Foundation

enum AuthType: String {
    case vk
    
    var keychainKey: String {
        switch self {
        case .vk: return rawValue
        }
    }
    
    var tokenType: Token.Type {
        switch self {
        case .vk: return VKToken.self
        }
    }
}

extension AuthType {
    static func getAuthType(url: URL) -> AuthType? {
        if url.scheme?.hasPrefix("vk") == true {
            return .vk
        }
        return nil
    }
}
