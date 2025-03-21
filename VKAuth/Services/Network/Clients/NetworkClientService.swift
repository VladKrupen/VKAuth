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
    
    init(
        authClient: AuthClient,
        tokenStorage: TokenStorage,
        userInfoClient: UserInfoClient
    ) {
        self.authClient = authClient
        self.tokenStorage = tokenStorage
        self.userInfoClient = userInfoClient
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
                print(error)
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
        userInfoClient.fetchUserInfo(authType: authType, token: token) { result in
            switch result {
            case .success(let user):
                completion(.success(user))
            case .failure(let error):
                completion(.failure(.userInfoError(error)))
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
