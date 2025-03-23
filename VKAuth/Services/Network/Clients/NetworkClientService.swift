//
//  NetworkClientService.swift
//  VKAuth
//
//  Created by Vlad on 21.03.25.
//

import Foundation

final class NetworkClientService: NetworkClient {
    weak var delegate: NetworkClientDelegate?
    private let authClient: AuthClient
    private let tokenStorage: TokenStorage
    private let userInfoClient: UserInfoClient
    private let refreshTokenClient: RefreshTokenClient
    
    init(
        authClient: AuthClient,
        tokenStorage: TokenStorage,
        userInfoClient: UserInfoClient,
        refreshTokenClient: RefreshTokenClient
    ) {
        self.authClient = authClient
        self.tokenStorage = tokenStorage
        self.userInfoClient = userInfoClient
        self.refreshTokenClient = refreshTokenClient
        setupDelegate()
    }
    
    private func setupDelegate() {
        authClient.delegate = self
    }
}

// MARK: - NetworkClient

extension NetworkClientService {
    func requestAuthorization(type: AuthType, completion: @escaping (Result<Void, NetworkClientError>) -> Void) {
        authClient.requestAuthorization(type: type) { [weak self] result in
            switch result {
            case .success(let token):
                self?.saveToken(authType: type, token: token, completion: completion)
            case .failure(let error):
                completion(.failure(.authError(error)))
            }
        }
    }
    
    func handleAuthCallbackURL(url: URL) {
        authClient.handleAuthCallbackURL(url: url)
    }
    
    func fetchUserInfo(completion: @escaping (Result<User, NetworkClientError>) -> Void) {
        guard let authType = AppConfig.shared.authType else {
            completion(.failure(.authTypeError))
            return
        }
        
        tokenStorage.getToken(authType: authType) { [weak self] result in
            switch result {
            case .success(let token):
                self?.fetchUserInfo(authType: authType, token: token, completion: completion)
            case .failure(let error):
                completion(.failure(.tokenStorageError(error)))
            }
        }
    }
    
    func logout(completion: @escaping (Result<Void, NetworkClientError>) -> Void) {
        guard let authType = AppConfig.shared.authType else {
            completion(.failure(.authTypeError))
            return
        }
        
        tokenStorage.getToken(authType: authType) { [weak self] result in
            switch result {
            case .success(let token):
                self?.invalidateToken(authType: authType, token: token, completion: completion)
            case .failure(let error):
                completion(.failure(.tokenStorageError(error)))
            }
        }
    }
}

// MARK: - Token Storage

extension NetworkClientService {
    private func saveToken(authType: AuthType, token: Token, completion: @escaping (Result<Void, NetworkClientError>) -> Void) {
        tokenStorage.saveToken(authType: authType, token: token) { result in
            switch result {
            case .success(let void):
                AppConfig.shared.authType = authType
                completion(.success(void))
            case .failure(let error):
                completion(.failure(.tokenStorageError(error)))
            }
        }
    }
}

// MARK: - UserInfoClient

extension NetworkClientService {
    private func fetchUserInfo(authType: AuthType, token: Token, completion: @escaping (Result<User, NetworkClientError>) -> Void) {
        userInfoClient.fetchUserInfo(authType: authType, token: token) { [weak self] result in
            switch result {
            case .success(let user):
                completion(.success(user))
            case .failure(let error):
                self?.handleUserInfoClientError(error: error, token: token, completion: completion)
            }
        }
    }
}

// MARK: - Handle Error

extension NetworkClientService {
    
    // MARK: - UserInfoClientError
    
    private func handleUserInfoClientError(error: UserInfoClientError, token: Token, completion: @escaping (Result<User, NetworkClientError>) -> Void) {
        switch error {
        case .vkError(let vKError):
            handleVKErrorForFetchUser(vkError: vKError, token: token, completion: completion)
        default:
            completion(.failure(.userInfoError(error)))
        }
    }
    
    // MARK: - AuthError
    
    private func handleAuthError(error: AuthError, token: Token, completion: @escaping (Result<Void, NetworkClientError>) -> Void) {
        switch error {
        case .vkError(let vKError):
            handleVKErrorForLogout(vkError: vKError, token: token, completion: completion)
        default:
            completion(.failure(.authError(error)))
        }
    }
    
    // MARK: - VKError
    
    private func handleVKErrorForFetchUser(vkError: VKError, token: Token, completion: @escaping (Result<User, NetworkClientError>) -> Void) {
        switch vkError {
        case .invalidToken:
            refreshTokenForFetchUserInfo(authType: .vk, token: token, completion: completion)
        case .accessDenied, .invalidClient:
            completion(.failure(.sessionInvalid))
        default:
            completion(.failure(.userInfoError(.vkError(vkError))))
        }
    }
    
    private func handleVKErrorForLogout(vkError: VKError, token: Token, completion: @escaping (Result<Void, NetworkClientError>) -> Void) {
        switch vkError {
        case .invalidToken:
            refreshTokenForLogout(authType: .vk, token: token, completion: completion)
        case .accessDenied, .invalidClient:
            completion(.failure(.sessionInvalid))
        default:
            completion(.failure(.authError(.vkError(vkError))))
        }
    }
}

// MARK: - RefreshTokenClient

extension NetworkClientService {
    private func refreshTokenForFetchUserInfo(authType: AuthType, token: Token, completion: @escaping (Result<User, NetworkClientError>) -> Void) {
        refreshTokenClient.refreshToken(authType: authType, token: token) { [weak self] result in
            switch result {
            case .success(let token):
                self?.fetchUserInfo(authType: authType, token: token, completion: completion)
            case .failure(let error):
                completion(.failure(.refreshTokenError(error)))
            }
        }
    }
    
    private func refreshTokenForLogout(authType: AuthType, token: Token, completion: @escaping (Result<Void, NetworkClientError>) -> Void) {
        refreshTokenClient.refreshToken(authType: authType, token: token) { [weak self] result in
            switch result {
            case .success:
                self?.logout(completion: completion)
            case .failure(let error):
                completion(.failure(.refreshTokenError(error)))
            }
        }
    }
}

// MARK: - Logout

extension NetworkClientService {
    private func invalidateToken(authType: AuthType, token: Token, completion: @escaping (Result<Void, NetworkClientError>) -> Void) {
        authClient.invalidateToken(authType: authType, token: token) { [weak self] result in
            switch result {
            case .success(let void):
                completion(.success(void))
            case .failure(let error):
                self?.handleAuthError(error: error, token: token, completion: completion)
            }
        }
    }
}

// MARK: - AuthClientDelegate

extension NetworkClientService: AuthClientDelegate {
    func vkAuthorizationSafariURL(url: URL?) {
        delegate?.authorizationSafariURL(authType: .vk, url: url)
    }
    
    func didFailAuthorization(with error: NetworkError) {
        delegate?.didFailAuthorization(with: .networkError(error))
    }
}
