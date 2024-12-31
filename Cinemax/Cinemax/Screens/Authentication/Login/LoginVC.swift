//
//  LoginVC.swift
//  Cinemax
//
//  Created by IPS-161 on 25/01/24.
//

import UIKit
import RxSwift
import RxCocoa

protocol LoginVCProtocol: class {
    func bindUI()
    func setUpBinding()
    func errorMsg(message:String)
}

class LoginVC: UIViewController {
    
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var emailAdressTxtFld: UITextField!
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var logInBtn: RoundedButton!
    @IBOutlet weak var passwordShowHideBtn: UIButton!
    @IBOutlet weak var emailAdressTxtFldView: RoundedCornerView!
    @IBOutlet weak var passwordTxtFldView: RoundedCornerView!
    @IBOutlet weak var userImg: UIImageView!
    
    var presenter : LoginVCPresenterProtocol?
    var presenterProducer : LoginVCPresenterProtocol.Producer!
    var userDataRepositoryManager: UserDataRepositoryManagerProtocol?
    private let bag = DisposeBag()
    var isPassworShow = false {
        didSet{
            passwordShowHideBtn.setImage(UIImage(named: isPassworShow ? "EyeBtnOpen" : "EyeBtnClose"), for: .normal)
            passwordTxtFld.isSecureTextEntry = isPassworShow ? false : true
        }
    }
    var doLogin: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userDataRepositoryManager = UserDataRepositoryManager.shared
        setupInputs()
        presenter?.viewDidload()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailAdressTxtFldView.borderColor = UIColor.appBlue!
        passwordTxtFldView.borderColor = UIColor.appBlue!
    }
    
    @IBAction func forgetPasswordBtnPrressed(_ sender: UIButton) {
        presenter?.goToResetPasswordVC()
    }
    
    @IBAction func passwordShowHideBtnPressed(_ sender: UIButton) {
        isPassworShow.toggle()
    }
    
    @IBAction func logInBtnPressed(_ sender: UIButton) {
        if(doLogin.value){
            presenter?.signIn(email: emailAdressTxtFld.text, password: passwordTxtFld.text)
        }else{
            showErrors()
        }
    }
    
}

extension LoginVC: LoginVCProtocol {
    
    func bindUI(){
        userDataRepositoryManager?.userFirstName.subscribe { event in
            if let element = event.element {
                DispatchQueue.main.async { [weak self] in
                    if element == "" {
                        self?.headingLbl.text = "Hi,There"
                    }else{
                        self?.headingLbl.text = "Hi,\(element)"
                    }
                }
            }
        }.disposed(by: disposeBag)
        userDataRepositoryManager?.userProfileImageUrl.subscribe{ event in
            if let element = event.element {
                DispatchQueue.main.async { [weak self] in
                    self?.userImg.WebImageLoadingFactory(urlString: element, placeholder: "person.fill")
                }
            }
        }.disposed(by: disposeBag)
    }
    
    func setupInputs(){
        presenter = presenterProducer((
            email: emailAdressTxtFld.rx.text.orEmpty.asDriver(),
            password: passwordTxtFld.rx.text.orEmpty.asDriver()
        ))
        emailAdressTxtFld.addTarget(self, action: #selector(textFieldDidChangeForEmailAddressTxtFld(_:)), for: .editingChanged)
        passwordTxtFld.addTarget(self, action: #selector(textFieldDidChangeForPasswordTxtFld(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChangeForEmailAddressTxtFld(_ textField: UITextField) {
        emailAdressTxtFldView.borderColor = UIColor.appBlue!
    }
    @objc func textFieldDidChangeForPasswordTxtFld(_ textField: UITextField) {
        passwordTxtFldView.borderColor = UIColor.appBlue!
    }
    
    func setUpBinding(){
        presenter?.output.enableLogin
            .debug("Enable Login Driver", trimOutput: false)
            .drive { [weak self] enableLogin in
                self?.doLogin.accept(enableLogin)
            }
            .disposed(by: bag)
    }
    
    func showErrors(){
        if (emailAdressTxtFld.text!.isEmpty) && (passwordTxtFld.text!.isEmpty) {
            showAllErrorVisuals()
            alertMsg(message: "Please fill Credentials.")
        }else if !(emailAdressTxtFld.text!.isEmailValid()) {
            if(emailAdressTxtFld.text!.isEmpty){
                alertMsg(message:"Fill Email.")
            }else{
                self.alertMsg(message:"Fill email in correct format.")
            }
            emailAdressTxtFldView.borderColor = .red
            emailAdressTxtFld.shake(duration: 0.07, repeatCount: 4, autoreverses: true)
        }else if !(passwordTxtFld.text!.isPasswordValid()) {
            if(passwordTxtFld.text!.isEmpty){
                alertMsg(message:"Fill Password.")
            }else{
                self.alertMsg(message:"Password should be 6 characters and contain at least one alphabet, one integer, and one symbol.")
            }
            passwordTxtFldView.borderColor = .red
            passwordTxtFld.shake(duration: 0.07, repeatCount: 4, autoreverses: true)
        }
    }
    
    func showAllErrorVisuals(){
        emailAdressTxtFldView.borderColor = .red
        emailAdressTxtFld.shake(duration: 0.07, repeatCount: 4, autoreverses: true)
        passwordTxtFldView.borderColor = .red
        passwordTxtFld.shake(duration: 0.07, repeatCount: 4, autoreverses: true)
    }
    
    func alertMsg(message:String){
        let customPopVC = CustomPopupVCBuilder.build(customPopupVCInputs: CustomPopupVCInputs.alert, popupLblHeadlineInput: "Alert!", popupSubheadlineInput: message)
        customPopVC.modalPresentationStyle = .overCurrentContext
        navigationController?.present(customPopVC,animated: true)
    }
    
    func errorMsg(message:String){
        let customPopVC = CustomPopupVCBuilder.build(customPopupVCInputs: CustomPopupVCInputs.error, popupLblHeadlineInput: "Error!", popupSubheadlineInput: message)
        customPopVC.modalPresentationStyle = .overCurrentContext
        navigationController?.present(customPopVC,animated: true)
    }
    
    func backBtnPressed(){
        navigationController?.popViewController(animated: true)
    }
    
}
