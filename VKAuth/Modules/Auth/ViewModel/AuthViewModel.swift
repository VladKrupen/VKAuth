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
    
    private let authClientService: AuthClientService
    
    init(
        authClientService: AuthClientService,
        onAction: @escaping (Action) -> Void
    ) {
        self.authClientService = authClientService
        self.onAction = onAction
        setupDelegate()
    }
    
    private func setupDelegate() {
        authClientService.delegate = self
    }
}

// MARK: - AuthViewModelProtocol

extension AuthViewModel {
    func performAuthorization(for type: AuthType) {
        authClientService.requestAuthorization(type: type) { [weak self] result in
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
        authClientService.handleAuthCallbackURL(url: url)
    }
}

// MARK: - AuthClientDelegate

extension AuthViewModel: AuthClientDelegate {
    func vkAuthorizationSafariURL(url: URL?) {
        onAction(.authWithURL(.vk, url))
    }
    
    func didFailAuthorization(with error: NetworkError) {
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
