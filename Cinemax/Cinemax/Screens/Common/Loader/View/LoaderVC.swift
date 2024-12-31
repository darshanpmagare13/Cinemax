//
//  LoaderVC.swift
//  Cinemax
//
//  Created by IPS-161 on 31/01/24.
//

import UIKit
import NVActivityIndicatorView

enum LoaderVCBackground {
    case withBlur
    case withoutBlur
}

class LoaderVC: UIViewController {
    
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    let indicatorSize: CGFloat = 50.0
    var type: NVActivityIndicatorType?
    var color: UIColor?
    var background: LoaderVCBackground?
    lazy var indicatior: NVActivityIndicatorView = {
        let frame = CGRect(x: (indicatorView.bounds.width - indicatorSize) / 2,
                           y: (indicatorView.bounds.height - indicatorSize) / 2,
                           width: indicatorSize,
                           height: indicatorSize)
        let indicator = NVActivityIndicatorView(frame: frame, type: type , color: color, padding:0)
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blurView.isHidden = true
        indicatorView.addSubview(indicatior)
        indicatior.startAnimating()
        if let background = background {
            setupLoaderBackground(background:background)
        }
    }
    
    func setupLoaderBackground(background:LoaderVCBackground){
        switch background {
        case.withBlur:
            blurView.isHidden = false
        case.withoutBlur:
            blurView.isHidden = true
        }
    }
    
}
