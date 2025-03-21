//
//  RefreshTokenClientService.swift
//  VKAuth
//
//  Created by Vlad on 21.03.25.
//

import Foundation

final class RefreshTokenClientService {
    private let authClient: AuthClient
    private let tokenStorage: TokenStorage
    
    init(
        authClient: AuthClient,
        tokenStorage: TokenStorage
    ) {
        self.authClient = authClient
        self.tokenStorage = tokenStorage
    }
    
    private func saveNewToken(authType: AuthType, token: Token, completion: @escaping (Result<Token, RefreshTokenError>) -> Void) {
        tokenStorage.saveToken(authType: authType, token: token) { result in
            switch result {
            case .success:
                completion(.success(token))
            case .failure(let error):
                completion(.failure(.storageError(error)))
            }
        }
    }
}

// MARK: - RefreshTokenClient

extension RefreshTokenClientService: RefreshTokenClient {
    func refreshToken(authType: AuthType, token: Token, completion: @escaping (Result<Token, RefreshTokenError>) -> Void) {
        authClient.refreshToken(authType: authType, token: token) { [weak self] result in
            switch result {
            case .success(let token):
                self?.saveNewToken(authType: authType, token: token, completion: completion)
            case .failure(let error):
                completion(.failure(.authError(error)))
            }
        }
    }
}
