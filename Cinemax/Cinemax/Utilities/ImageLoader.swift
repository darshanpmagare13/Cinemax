//
//  ImageLoader.swift
//  Cinemax
//
//  Created by IPS-161 on 05/02/24.
//

import Foundation
import UIKit

class ImageLoader {
    
    enum PlaceHolderImageTypes {
        case systemName
        case named
    }
    
    private static let imageCache = NSCache<AnyObject, UIImage>()
    
    static func loadImage(imageView: UIImageView, imageUrl: String, placeHolderType: PlaceHolderImageTypes, placeHolderImage: String) {
        
        // Show activity indicator
        let activityLoader = UIActivityIndicatorView(style: .white)
        activityLoader.startAnimating()
        activityLoader.center = imageView.center
        imageView.addSubview(activityLoader)
        
        if let cachedImage = self.imageCache.object(forKey: imageUrl as AnyObject) {
            // Image already cached
            DispatchQueue.main.async {
                activityLoader.removeFromSuperview()
                setImageViewWithFade(imageView: imageView, image: cachedImage)
            }
        } else {
            // Image not cached, download it
            DispatchQueue.global(qos: .userInitiated).async {
                if let url = URL(string: imageUrl),let imageData = try? Data(contentsOf: url) {
                    if let image = UIImage(data: imageData) {
                        self.imageCache.setObject(image, forKey: imageUrl as AnyObject)
                        DispatchQueue.main.async {
                            activityLoader.removeFromSuperview()
                            setImageViewWithFade(imageView: imageView, image: image)
                        }
                    }
                } else {
                    // Handle download failure if needed
                    DispatchQueue.main.async {
                        activityLoader.removeFromSuperview()
                        switch placeHolderType {
                        case .systemName:
                            let image = UIImage(systemName: placeHolderImage)
                            setImageViewWithFade(imageView: imageView, image: image)
                        case .named:
                            let image = UIImage(named: placeHolderImage)
                            setImageViewWithFade(imageView: imageView, image: image)
                        }
                    }
                }
            }
        }
    }
    
    private static func setImageViewWithFade(imageView: UIImageView, image: UIImage?) {
        UIView.transition(with: imageView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            imageView.image = image
        }, completion: nil)
    }
}
