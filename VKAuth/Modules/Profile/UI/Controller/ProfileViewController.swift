//
//  ProfileViewController.swift
//  VKAuth
//
//  Created by Vlad on 19.03.25.
//

import UIKit
import Combine

final class ProfileViewController: BaseViewController {
    private let viewModel: ProfileViewModelProtocol
    private let contentView: ProfileView = ProfileView()
    
    // MARK: - Init
    
    init(viewModel: ProfileViewModelProtocol) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Life Cycle
    
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        viewModel.fetchUserInfo()
    }
}

// MARK: - Bindings

extension ProfileViewController {
    private func setupBindings() {
        viewModel.userPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                self?.configureView(user: user)
            }
            .store(in: &viewModel.cancellables)
    }
}

// MARK: - Configure View

extension ProfileViewController {
    private func configureView(user: User) {
        contentView.configureInfoCard(
            firstName: user.firstName,
            lastName: user.lastName
        )
        contentView.configureAvatar(avatar: user.avatar)
        contentView.showProfileElements()
    }
}
