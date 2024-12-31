//
//  UIView+Extensions.swift
//  Cinemax
//
//  Created by Nirav Patel on 18/07/24.
//

import UIKit

private var containerViewKey: UInt8 = 0

extension UIView {
    
    private var containerView: UIView? {
        get {
            return objc_getAssociatedObject(self, &containerViewKey) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &containerViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func showLoadingView(backgroundColor: UIColor, indicatorColor: UIColor) {
        containerView = UIView(frame: self.bounds)
        self.addSubview(containerView!)
        containerView!.backgroundColor = backgroundColor
        containerView!.alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.containerView!.alpha = 0.8
        }
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = indicatorColor
        containerView!.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        activityIndicator.startAnimating()
    }
    
    func dismissLoadingView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.containerView?.removeFromSuperview()
            self.containerView = nil
        }
    }
    
    func showErrorView() {
        containerView = UIView(frame: self.bounds)
        self.addSubview(containerView!)
        containerView!.backgroundColor = .white
        containerView!.alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.containerView!.alpha = 0.8
        }
        
        let errorImageView = UIImageView(image: UIImage(systemName: "exclamationmark.triangle.fill"))
        errorImageView.tintColor = .black
        errorImageView.contentMode = .scaleAspectFit
        errorImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView!.addSubview(errorImageView)
        
        let errorLabel = UILabel()
        errorLabel.text = "Something Went Wrong."
        errorLabel.textColor = .black
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView!.addSubview(errorLabel)
        
        NSLayoutConstraint.activate([
            errorImageView.centerXAnchor.constraint(equalTo: containerView!.centerXAnchor),
            errorImageView.centerYAnchor.constraint(equalTo: containerView!.centerYAnchor, constant: -20),
            errorImageView.heightAnchor.constraint(equalToConstant: 50),
            errorImageView.widthAnchor.constraint(equalToConstant: 50),
            
            errorLabel.topAnchor.constraint(equalTo: errorImageView.bottomAnchor, constant: 10),
            errorLabel.centerXAnchor.constraint(equalTo: containerView!.centerXAnchor)
        ])
    }
    
    func dismissErrorView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.containerView?.removeFromSuperview()
            self.containerView = nil
        }
    }
}

