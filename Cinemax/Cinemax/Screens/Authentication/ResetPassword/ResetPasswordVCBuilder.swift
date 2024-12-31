//
//  ResetPasswordVCBuilder.swift
//  Cinemax
//
//  Created by IPS-161 on 29/01/24.
//

import Foundation
import UIKit

public final class ResetPasswordVCBuilder {
    
    static var backButtonPressedClosure : (()->())?
    
    static func build() -> UIViewController {
        let storyboard = UIStoryboard.Authentication
        let resetPasswordVC = storyboard.instantiateViewController(withIdentifier: "ResetPasswordVC") as! ResetPasswordVC
        let interactor = ResetPasswordVCInteractor()
        resetPasswordVC.presenterProducer = {
            ResetPasswordVCPresenter(view: resetPasswordVC, interactor: interactor, input: $0)
        }
        let backButton = UIBarButtonItem(image: UIImage(named: "BackBtn"), style: .plain, target: self, action: #selector(backButtonPressed))
        resetPasswordVC.navigationItem.leftBarButtonItem = backButton
        ResetPasswordVCBuilder.backButtonPressedClosure = { [weak resetPasswordVC] in
            resetPasswordVC?.backBtnPressed()
        }
        return resetPasswordVC
    }
    
    @objc static func backButtonPressed() {
        backButtonPressedClosure?()
    }
    
}
