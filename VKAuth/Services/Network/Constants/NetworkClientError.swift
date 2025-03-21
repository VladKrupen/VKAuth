//
//  NetworkClientError.swift
//  VKAuth
//
//  Created by Vlad on 21.03.25.
//

import Foundation

enum NetworkClientError: LocalizedError {
    case authError(AuthError)
    case authTypeError
    case networkError(NetworkError)
    case tokenStorageError(TokenStorageError)
    case userInfoError(UserInfoClientError)
    case refreshTokenError(RefreshTokenError)
    case sessionInvalid
}
