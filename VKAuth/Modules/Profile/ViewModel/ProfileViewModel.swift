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
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
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
                // TODO: - Handle Error
                print(error)
            }
        }
    }
}
