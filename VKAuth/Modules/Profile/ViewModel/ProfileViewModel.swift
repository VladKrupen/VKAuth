//
//  ProfileViewModel.swift
//  VKAuth
//
//  Created by Vlad on 19.03.25.
//

import Foundation
import Combine

protocol ProfileViewModelProtocol: AnyObject {
    var userPublisher: PassthroughSubject<User, Never> { get }
    var cancellables: Set<AnyCancellable> { get set }
    func fetchUserInfo()
}

final class ProfileViewModel: ProfileViewModelProtocol {
    var userPublisher: PassthroughSubject<User, Never> = .init()
    var cancellables: Set<AnyCancellable> = .init()
    private let networkClient: NetworkClient
    private let onAction: (Action) -> Void
    
    init(
        networkClient: NetworkClient,
        onAction: @escaping (Action) -> Void
    ) {
        self.networkClient = networkClient
        self.onAction = onAction
    }
}

// MARK: - ProfileViewModelProtocol

extension ProfileViewModel {
    func fetchUserInfo() {
        networkClient.fetchUserInfo { [weak self] result in
            switch result {
            case .success(let user):
                self?.userPublisher.send(user)
            case .failure(let error):
                self?.handleError(error: error)
            }
        }
    }
}

// MARK: - Action

extension ProfileViewModel {
    enum Action {
        case redirectToAuth
    }
}

// MARK: - Handle Error

extension ProfileViewModel {
    private func handleError(error: NetworkClientError) {
        switch error {
        case .sessionInvalid:
            onAction(.redirectToAuth)
        default:
            // TODO: - Handle Error
            print(error)
        }
    }
}
