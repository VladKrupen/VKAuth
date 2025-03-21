//
//  AuthViewController.swift
//  VKAuth
//
//  Created by Vlad on 17.03.25.
//

import UIKit

final class AuthViewController: BaseViewController {
    private let viewModel: AuthViewModelProtocol
    private let contentView: AuthView = AuthView()
    
    // MARK: - Init
    
    init(viewModel: AuthViewModelProtocol) {
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
        setupTargets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    func processAuthCallbackURL(url: URL?) {
        viewModel.handleAuthCallbackURL(url: url)
    }
    
    // MARK: - Targets
    
    private func setupTargets() {
        contentView.vkAuthButton.addTarget(self, action: #selector(vkAuthButtonTapped), for: .touchUpInside)
    }
}

// MARK: - OBJC

extension AuthViewController {
    @objc private func vkAuthButtonTapped() {
        viewModel.performAuthorization(for: .vk)
    }
}
