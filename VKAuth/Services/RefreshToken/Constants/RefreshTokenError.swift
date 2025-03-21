//
//  RefreshTokenError.swift
//  VKAuth
//
//  Created by Vlad on 21.03.25.
//

import Foundation

enum RefreshTokenError: LocalizedError {
    case authError(AuthError)
    case storageError(TokenStorageError)
}
