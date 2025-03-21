//
//  TokenStorageError.swift
//  VKAuth
//
//  Created by Vlad on 21.03.25.
//

import Foundation

enum TokenStorageError: LocalizedError {
    case saveTokenError(KeychainService.KeychainError)
    case tokenNotFoundError(KeychainService.KeychainError)
}
