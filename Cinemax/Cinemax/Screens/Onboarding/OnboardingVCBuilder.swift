//
//  OnboardingVCBuilder.swift
//  Cinemax
//
//  Created by IPS-161 on 24/01/24.
//

import Foundation
import UIKit

public final class OnboardingVCBuilder {
    static func build(factory:NavigationFactoryClosure) -> UIViewController {
        let storyboard = UIStoryboard.Onboarding
        let onboardingVC = storyboard.instantiateViewController(withIdentifier: "OnboardingVC") as! OnboardingVC
        let interactor = OnboardingVCInteractor()
        let router = OnboardingVCRouter(viewController: onboardingVC)
        let presenter = OnboardingVCPresenter(view: onboardingVC, interactor: interactor, router: router)
        onboardingVC.presenter = presenter
        return factory(onboardingVC)
    }
}
