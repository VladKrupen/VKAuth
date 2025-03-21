//
//  AuthViewModel.swift
//  VKAuth
//
//  Created by Vlad on 17.03.25.
//

import Foundation

protocol AuthViewModelProtocol: AnyObject {
    func performAuthorization(for type: AuthType)
    func handleAuthCallbackURL(url: URL?)
}

final class AuthViewModel: AuthViewModelProtocol {
    private let onAction: (Action) -> Void
    private let networkClient: NetworkClient
    
    init(
        networkClient: NetworkClient,
        onAction: @escaping (Action) -> Void
    ) {
        self.networkClient = networkClient
        self.onAction = onAction
        setupDelegate()
    }
    
    private func setupDelegate() {
        networkClient.delegate = self
    }
}

// MARK: - AuthViewModelProtocol

extension AuthViewModel {
    func performAuthorization(for type: AuthType) {
        networkClient.requestAuthorization(type: type) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.onAction(.finish)
                case .failure(let error):
                    // TODO: - Handle Error
                    print(error)
                }
            }
        }
    }
    
    func handleAuthCallbackURL(url: URL?) {
        guard let url else {
            // TODO: - Handle Error
            return
        }
        networkClient.handleAuthCallbackURL(url: url)
    }
}

// MARK: - NetworkClientDelegate

extension AuthViewModel: NetworkClientDelegate {
    func authorizationSafariURL(authType: AuthType, url: URL?) {
        onAction(.authWithURL(authType, url))
    }
    
    func didFailAuthorization(with error: NetworkClientError) {
        // TODO: - Handle Error
        print(error)
    }
}

// MARK: - Action

extension AuthViewModel {
    enum Action {
        case authWithURL(AuthType, URL?)
        case finish
    }
}
