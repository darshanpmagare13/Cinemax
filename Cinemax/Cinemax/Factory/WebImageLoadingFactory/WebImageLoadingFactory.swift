//
//  WebImageLoadingFactory.swift
//  Cinemax
//
//  Created by IPS-161 on 14/03/24.
//

import Foundation
import Kingfisher
import UIKit

extension UIImageView {
    func WebImageLoadingFactory(urlString: String, placeholder: String) {
        let url = URL(string: urlString)
        let placeholderImg = UIImage(systemName: placeholder)
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = .white
        activityIndicator.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        self.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        self.kf.setImage(with: url, placeholder: placeholderImg) { result in
            switch result {
            case .success(_):
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            case .failure(_):
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            }
        }
    }
}
