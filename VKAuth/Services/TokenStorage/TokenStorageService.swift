//
//  TokenStorageService.swift
//  VKAuth
//
//  Created by Vlad on 21.03.25.
//

import Foundation

final class TokenStorageService {
    private var token: Token?
    private let keychainService: KeychainService
    
    init(keychainService: KeychainService) {
        self.keychainService = keychainService
        loadInitialToken()
    }
    
    private func loadInitialToken() {
        guard let authType = AppConfig.shared.authType else {
            return
        }
        
        getToken(authType: authType) { [weak self] result in
            switch result {
            case .success(let token):
                self?.token = token
            case .failure(let error):
                // TODO: Handle Error
                print(error)
            }
        }
    }
}

// MARK: - TokenStorage

extension TokenStorageService: TokenStorage {
    func saveToken(authType: AuthType, token: Token, completion: @escaping (Result<Void, TokenStorageError>) -> Void) {
        saveTokenInKeychain(authType: authType, token: token) { [weak self] result in
            switch result {
            case .success():
                self?.token = token
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getToken(authType: AuthType, completion: @escaping (Result<Token, TokenStorageError>) -> Void) {
        if let token {
            completion(.success(token))
        } else {
            getTokenFromKeychain(authType: authType, completion: completion)
        }
    }
}

// MARK: - KeychainService

extension TokenStorageService {
    private func saveTokenInKeychain(authType: AuthType, token: Token, completion: @escaping (Result<Void, TokenStorageError>) -> Void) {
        keychainService.saveTokens(authType: authType, token: token) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(.keychainError(error)))
            }
        }
    }
    
    private func getTokenFromKeychain(authType: AuthType, completion: @escaping (Result<Token, TokenStorageError>) -> Void) {
        keychainService.getTokens(authType: authType) { result in
            switch result {
            case .success(let token):
                completion(.success(token))
            case .failure(let error):
                completion(.failure(.keychainError(error)))
            }
        }
    }
}
