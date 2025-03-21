//
//  TokenStorage.swift
//  VKAuth
//
//  Created by Vlad on 21.03.25.
//

import Foundation

protocol TokenStorage: AnyObject {
    func saveToken(authType: AuthType, token: Token, completion: @escaping (Result<Void, TokenStorageError>) -> Void)
    func getToken(authType: AuthType, completion: @escaping (Result<Token, TokenStorageError>) -> Void)
}
