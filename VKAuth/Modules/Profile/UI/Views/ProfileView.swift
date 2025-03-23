//
//  ProfileView.swift
//  VKAuth
//
//  Created by Vlad on 19.03.25.
//

import UIKit
import SDWebImage

final class ProfileView: BaseView {
    
    // MARK: - UI
    
    private let avatarImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.black.cgColor
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.tintColor = .systemGray
        return $0
    }(UIImageView())
    
    private let firstNameLabelView = ProfileLabelView()
    private let lastNameLabelView = ProfileLabelView()
    
    private let infoCardView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.spacing = 16
        $0.layer.cornerRadius = 16
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.black.cgColor
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        return $0
    }(UIStackView())
    
    let logoutButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("Выйти", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.layer.cornerRadius = 16
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.black.cgColor
        return $0
    }(UIButton(type: .system))
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        layoutElements()
        hideProfileElements()
    }
}

// MARK: - Configure View

extension ProfileView {
    func showProfileElements() {
        avatarImageView.isHidden = false
        infoCardView.isHidden = false
        logoutButton.isHidden = false
    }
    
    func configureInfoCard(firstName: String, lastName: String) {
        infoCardView.isHidden = false
        firstNameLabelView.configure(placeholder: "Имя", value: firstName)
        lastNameLabelView.configure(placeholder: "Фамилия", value: lastName)
    }
    
    func configureAvatar(avatar: String?) {
        let placeholder = UIImage(systemName: "person.fill")?.withRenderingMode(.alwaysTemplate)
        avatarImageView.sd_setImage(with: URL(string: avatar ?? .init()), placeholderImage: placeholder)
    }
    
    private func hideProfileElements() {
        avatarImageView.isHidden = true
        infoCardView.isHidden = true
        logoutButton.isHidden = true
    }
}

// MARK: - Layout

extension ProfileView {
    private func layoutElements() {
        layoutAvatarImageView()
        layoutInfoCardView()
        layoutLogoutButton()
    }
    
    private func layoutAvatarImageView() {
        addSubview(avatarImageView)
        
        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 200),
            avatarImageView.heightAnchor.constraint(equalToConstant: 200),
            
            avatarImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            avatarImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    private func layoutInfoCardView() {
        [firstNameLabelView, lastNameLabelView].forEach { infoCardView.addArrangedSubview($0) }
        addSubview(infoCardView)
        
        NSLayoutConstraint.activate([
            infoCardView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 40),
            infoCardView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            infoCardView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    private func layoutLogoutButton() {
        addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            logoutButton.heightAnchor.constraint(equalToConstant: 50),
            logoutButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            logoutButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            logoutButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - Update Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCornerRadiusForAvatar()
    }
    
    private func updateCornerRadiusForAvatar() {
        let size = avatarImageView.bounds.size
        let radius = size.width / 2
        avatarImageView.layer.cornerRadius = radius
    }
}
