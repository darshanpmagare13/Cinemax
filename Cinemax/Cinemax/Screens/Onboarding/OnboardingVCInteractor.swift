//
//  OnboardingVCInteractor.swift
//  Cinemax
//
//  Created by IPS-161 on 24/01/24.
//

import Foundation
import UIKit

protocol OnboardingVCInteractorProtocol {
    func loadOnboardingData() async throws -> [OnboardingVCEntity]
}

class OnboardingVCInteractor {
    
}

extension OnboardingVCInteractor: OnboardingVCInteractorProtocol {
    
    func loadOnboardingData() async throws -> [OnboardingVCEntity] {
        var dataSource = [OnboardingVCEntity]()
        guard let img1 = UIImage(named:"onboardingImg1"),
              let img2 = UIImage(named:"onboardingImg2"),
              let img3 = UIImage(named:"onboardingImg3") else {
                  throw fatalError()
              }
        dataSource.append(contentsOf: [OnboardingVCEntity(img: img1, headline: "The biggest international and local film streaming", subHeadline: "Semper in cursus magna et eu varius nunc adipiscing. Elementum justo, laoreet id sem semper parturient."),OnboardingVCEntity(img: img2, headline: "Offers ad-free viewing of high quality", subHeadline: "Semper in cursus magna et eu varius nunc adipiscing. Elementum justo, laoreet id sem semper parturient."),OnboardingVCEntity(img: img3, headline: "Our service brings together your favorite series", subHeadline: "Semper in cursus magna et eu varius nunc adipiscing. Elementum justo, laoreet id sem semper parturient.")])
        return dataSource
    }
    
}
