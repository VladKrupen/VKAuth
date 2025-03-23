//
//  AuthClientService.swift
//  VKAuth
//
//  Created by Vlad on 18.03.25.
//

import Foundation

final class AuthClientService: AuthClient {
    weak var delegate: AuthClientDelegate?
    private let vkAuthClient: VKAuthClient
    private var authCompletion: ((Result<Token, NetworkError>) -> Void)?
    
    init(vkAuthClient: VKAuthClient) {
        self.vkAuthClient = vkAuthClient
    }
    
    func requestAuthorization(type: AuthType, completion: @escaping (Result<Token, AuthError>) -> Void) {
        switch type {
        case .vk:
            requestVKAuthorization(completion: completion)
        }
    }
    
    func refreshToken(authType: AuthType, token: Token, completion: @escaping (Result<Token, AuthError>) -> Void) {
        switch authType {
        case .vk:
            refreshVKToken(token: token, completion: completion)
        }
    }
    
    func invalidateToken(authType: AuthType, token: Token, completion: @escaping (Result<Void, AuthError>) -> Void) {
        switch authType {
        case .vk:
            invalidateVKToken(token: token, completion: completion)
        }
    }
}

// MARK: - Handle

extension AuthClientService {
    func handleAuthCallbackURL(url: URL) {
        guard let authType = AuthType.getAuthType(url: url) else {
            delegate?.didFailAuthorization(with: .invalidTokenType)
            return
        }
        
        switch authType {
        case .vk:
            handleVKAuthURL(url: url)
        }
    }
    
    private func handleAuthResult(authType: AuthType, completion: @escaping (Result<Token, AuthError>) -> Void) {
        authCompletion = { result in
            switch result {
            case .success(let token):
                completion(.success(token))
            case .failure(let error):
                completion(.failure(.invalidAuth(error)))
            }
        }
    }
}

// MARK: - VKAuthorization

extension AuthClientService  {
    private func requestVKAuthorization(completion: @escaping (Result<Token, AuthError>) -> Void) {
        let vkAuthURL = vkAuthClient.generateSafariAuthURL()
        delegate?.vkAuthorizationSafariURL(url: vkAuthURL)
        handleAuthResult(authType: .vk, completion: completion)
    }
    
    private func handleVKAuthURL(url: URL) {
        vkAuthClient.requestTokens(url: url) { [weak self] result in
            switch result {
            case .success(let vkToken):
                self?.authCompletion?(.success(vkToken))
            case .failure(let error):
                self?.authCompletion?(.failure(error))
            }
        }
    }
    
    private func refreshVKToken(token: Token, completion: @escaping (Result<Token, AuthError>) -> Void) {
        guard let vkToken = token as? VKToken else {
            completion(.failure(.invalidAuth(.invalidTokenType)))
            return
        }
        vkAuthClient.refreshTokens(vkToken) { result in
            switch result {
            case .success(let vkToken):
                completion(.success(vkToken))
            case .failure(let error):
                completion(.failure(.invalidAuth(error)))
            }
        }
    }
    
    private func invalidateVKToken(token: Token, completion: @escaping (Result<Void, AuthError>) -> Void) {
        guard let vkToken = token as? VKToken else {
            completion(.failure(.invalidAuth(.invalidTokenType)))
            return
        }
        vkAuthClient.invalidateToken(vkToken, completion: completion)
    }
}
