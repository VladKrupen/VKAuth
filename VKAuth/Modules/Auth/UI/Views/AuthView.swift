//
//  AuthView.swift
//  VKAuth
//
//  Created by Vlad on 18.03.25.
//

import UIKit

final class AuthView: BaseView {
    
    // MARK: - UI
    
    private let titleLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 24, weight: .bold)
        $0.textColor = .black
        $0.text = "Авторизация"
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    let vkAuthButton = AuthButton(
        title: "Войтии с VK ID",
        uiImage: .vkLogoAuthButton,
        textColor: .white,
        backgroundColor: .vkBlue
    )
    
    private let authButtonsStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.spacing = 10
        return $0
    }(UIStackView())
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        layoutElements()
    }
    
    // MARK: - Layout
    
    private func layoutElements() {
        layoutTitleLabel()
        layoutAuthButtonsStackView()
    }
    
    private func layoutTitleLabel() {
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }
    
    private func layoutAuthButtonsStackView() {
        [vkAuthButton].forEach { authButtonsStackView.addArrangedSubview($0) }
        addSubview(authButtonsStackView)
        
        NSLayoutConstraint.activate([
            vkAuthButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            vkAuthButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            authButtonsStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -40)
        ])
    }
}
