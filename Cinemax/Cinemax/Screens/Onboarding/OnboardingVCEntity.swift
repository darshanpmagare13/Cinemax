//
//  OnboardingVCEntity.swift
//  Cinemax
//
//  Created by IPS-161 on 24/01/24.
//

import Foundation
import UIKit

struct OnboardingVCEntity {
    var img : UIImage
    var headline: String
    var subHeadline: String
    init(img : UIImage,headline: String, subHeadline: String){
        self.img = img
        self.headline = headline
        self.subHeadline = subHeadline
    }
}
