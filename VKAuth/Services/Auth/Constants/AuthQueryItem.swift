//
//  AuthQueryItem.swift
//  VKAuth
//
//  Created by Vlad on 18.03.25.
//

import Foundation

enum AuthQueryItem: String {
    case state, prompt, scope, code
    case responseType = "response_type"
    case codeChallenge = "code_challenge"
    case codeChallengeMethod = "code_challenge_method"
    case clientId = "client_id"
    case redirectUri = "redirect_uri"
    case deviceId = "device_id"
}

// MARK: - Build QueryItem

extension AuthQueryItem {
    func queryItem(value: String) -> URLQueryItem {
        return URLQueryItem(name: self.rawValue, value: value)
    }
}
