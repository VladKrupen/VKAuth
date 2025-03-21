//
//  AuthClientService.swift
//  VKAuth
//
//  Created by Vlad on 18.03.25.
//

import Foundation

final class AuthClientService: AuthClient {
    weak var delegate: AuthClientDelegate?
    private let keychainService: KeychainService
    private let vkAuthClient: VKAuthClient
    private var authCompletion: ((Result<Token, NetworkError>) -> Void)?
    
    init(
        keychainService: KeychainService,
        vkAuthClient: VKAuthClient
    ) {
        self.keychainService = keychainService
        self.vkAuthClient = vkAuthClient
    }
    
    func requestAuthorization(type: AuthType, completion: @escaping (Result<Void, AuthError>) -> Void) {
        switch type {
        case .vk:
            requestVKAuthorization(completion: completion)
        }
    }
    
    func fetchUserInfo(completion: @escaping (Result<User, AuthError>) -> Void) {
        guard let authType = AppConfig.shared.authType else {
            completion(.failure(.invalidAuth))
            return
        }
        
        getTokens(authType: authType) { [weak self] result in
            switch result {
            case .success(let token):
                self?.handleReceivedTokensForFetchUserInfo(authType: authType, token: token, completion: completion)
            case .failure(let error):
                print(error)
                completion(.failure(.invalidUserInfo))
            }
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
        authCompletion = { [weak self] result in
            switch result {
            case .success(let token):
                self?.saveTokens(authType: authType, token: token, completion: completion)
            case .failure(let error):
                print(error)
                completion(.failure(.invalidAuth))
            }
        }
    }

    private func handleReceivedTokensForFetchUserInfo(authType: AuthType, token: Token, completion: @escaping (Result<User, AuthError>) -> Void) {
        switch authType {
        case .vk:
            fetchVKUserInfo(token: token, completion: completion)
        }
    }
}

// MARK: - VKAuthorization

extension AuthClientService  {
    private func requestVKAuthorization(completion: @escaping (Result<Void, AuthError>) -> Void) {
        let vkAuthURL = vkAuthClient.generateSafariAuthURL()
        delegate?.vkAuthorizationSafariURL(url: vkAuthURL)
        handleAuthResult(authType: .vk) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
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
    
    private func fetchVKUserInfo(token: Token, completion: @escaping (Result<User, AuthError>) -> Void) {
        guard let vkToken = token as? VKToken else {
            completion(.failure(.invalidUserInfo))
            return
        }
        vkAuthClient.fetchUserInfo(vkToken: vkToken) { result in
            switch result {
            case .success(let vkUser):
                completion(.success(vkUser))
            case .failure(let error):
                print(error)
                completion(.failure(.invalidUserInfo))
            }
        }
    }
}

// MARK: - KeychainService

extension AuthClientService {
    private func saveTokens(authType: AuthType, token: Token, completion: @escaping (Result<Token, AuthError>) -> Void) {
        keychainService.saveTokens(authType: authType, token: token) { result in
            switch result {
            case .success:
                AppConfig.shared.authType = authType
                completion(.success(token))
            case .failure(let error):
                print(error)
                completion(.failure(.invalidAuth))
            }
        }
    }
    
    private func getTokens(authType: AuthType, completion: @escaping (Result<Token, AuthError>) -> Void) {
        keychainService.getTokens(authType: authType) { result in
            switch result {
            case .success(let token):
                completion(.success(token))
            case .failure(let error):
                print(error)
                completion(.failure(.invalidAuth))
            }
        }
    }
}
