//
//  UIViewController+Ex.swift
//  VKAuth
//
//  Created by Vlad on 23.03.25.
//

import UIKit

// MARK: - Alert

extension UIViewController {
    func showDestructiveAlert(title: String?, message: String?, onDestructive: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let destructiveAction = UIAlertAction(title: "Да", style: .destructive) { _ in
            onDestructive()
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        alertController.addAction(destructiveAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
}

// MARK: - Spiner

extension UIViewController {
    func showSpiner() {
        let overlayView: UIView = {
            $0.backgroundColor = .black.withAlphaComponent(0.5)
            $0.tag = 100
            return $0
        }(UIView(frame: view.bounds))
        
        let spinerView: UIActivityIndicatorView = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.style = .large
            $0.hidesWhenStopped = true
            $0.startAnimating()
            return $0
        }(UIActivityIndicatorView())
        
        overlayView.addSubview(spinerView)
        
        NSLayoutConstraint.activate([
            spinerView.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
            spinerView.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor)
        ])
        
        view.addSubview(overlayView)
    }
    
    func hideSpiner() {
        if let overlayView = view.viewWithTag(100) {
            overlayView.removeFromSuperview()
        }
    }
}
