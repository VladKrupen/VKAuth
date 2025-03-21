//
//  UserInfoClientError.swift
//  VKAuth
//
//  Created by Vlad on 21.03.25.
//

import Foundation

enum UserInfoClientError: LocalizedError {
    case invalidVKToken
    case networkError(NetworkError)
    case invalidJsonFormat(String)
    case decodingError(Error)
    case vkError(VKError)
}
