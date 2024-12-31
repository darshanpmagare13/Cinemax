//
//  SignUpVC.swift
//  Cinemax
//
//  Created by IPS-161 on 29/01/24.
//

import UIKit
import GoogleSignIn
import FirebaseAuth

protocol SignUpVCProtocol: class {
    func errorAlert(message:String)
}

class SignUpVC: UIViewController {
    
    var presenter: SignUpVCPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidload()
    }
    
    
    @IBAction func signUpBtnPressed(_ sender: UIButton) {
        presenter?.goToSignUpCredentialVC()
    }
    
    
    @IBAction func loginBtnPressed(_ sender: UIButton) {
        presenter?.goToLoginVC()
    }
    
    
    @IBAction func signInWithGoogleBtnPressed(_ sender: UIButton) {
        presenter?.signinWithGoogle(view: self)
    }
    
}

extension SignUpVC : SignUpVCProtocol {
    
    func errorAlert(message:String){
        Alert.shared.alertOk(title: "Error", message: message, presentingViewController: self) { _ in}
    }
    
}
