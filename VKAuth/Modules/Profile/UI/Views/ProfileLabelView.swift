//
//  ProfileLabelView.swift
//  VKAuth
//
//  Created by Vlad on 21.03.25.
//

import UIKit

final class ProfileLabelView: BaseView {
    
    // MARK: UI
    
    private let placeholderLabel: UILabel = {
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = .black
        return $0
    }(UILabel())
    
    private let valueLabel: UILabel = {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .black
        return $0
    }(UILabel())
    
    private let hStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.spacing = 10
        return $0
    }(UIStackView())
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        layoutHStackView()
    }
    
    // MARK: - Configure
    
    func configure(placeholder: String, value: String) {
        placeholderLabel.text = "\(placeholder):"
        valueLabel.text = value
    }
    
    // MARK: - Layout
    
    private func layoutHStackView() {
        [placeholderLabel, valueLabel].forEach { hStackView.addArrangedSubview($0) }
        addSubview(hStackView)
        
        NSLayoutConstraint.activate([
            hStackView.topAnchor.constraint(equalTo: topAnchor),
            hStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            hStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            hStackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor)
        ])
    }
}
