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
        setupTarget()
        setupBindings()
        viewModel.fetchUserInfo()
    }
    
    private func setupTarget() {
        contentView.logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
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

// MARK: - OBJC

extension ProfileViewController {
    @objc private func logoutButtonTapped() {
        showDestructiveAlert(title: "Выйти", message: "Вы действительно хотите выйти из вашего аккаунт?") { [weak self] in
            self?.showSpiner()
            self?.viewModel.logout()
        }
    }
}
