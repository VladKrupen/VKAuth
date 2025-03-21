//
//  AuthButton.swift
//  VKAuth
//
//  Created by Vlad on 18.03.25.
//

import UIKit

final class AuthButton: BaseButton {
    
    // MARK: - Intrinsic Content Size
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 44)
    }
    
    // MARK: - UI
    
    private let vkLogoImageView: UIImageView = {
        $0.contentMode = .scaleAspectFit
        $0.isUserInteractionEnabled = false
        return $0
    }(UIImageView(frame: .init(x: 0, y: 0, width: 28, height: 28)))
    
    private let signInLabel: UILabel = {
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        return $0
    }(UILabel())
    
    private let hStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.spacing = 10
        $0.isUserInteractionEnabled = false
        return $0
    }(UIStackView())
    
    // MARK: - Init
    
    init(
        title: String,
        uiImage: UIImage?,
        textColor: UIColor,
        backgroundColor: UIColor
    ) {
        super.init(frame: .zero)
        setupButton(
            title: title,
            uiImage: uiImage,
            textColor: textColor,
            backgroundColor: backgroundColor
        )
        layoutHStackView()
    }
    
    // MARK: - Setup
    
    private func setupButton(
        title: String,
        uiImage: UIImage?,
        textColor: UIColor,
        backgroundColor: UIColor
    ) {
        self.layer.cornerRadius = 16
        self.signInLabel.text = title
        self.signInLabel.textColor = textColor
        self.vkLogoImageView.image = uiImage
        self.backgroundColor = backgroundColor
    }
    
    // MARK: - Layout
    
    private func layoutHStackView() {
        [vkLogoImageView, signInLabel].forEach { hStackView.addArrangedSubview($0) }
        addSubview(hStackView)
        
        NSLayoutConstraint.activate([
            hStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            hStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
