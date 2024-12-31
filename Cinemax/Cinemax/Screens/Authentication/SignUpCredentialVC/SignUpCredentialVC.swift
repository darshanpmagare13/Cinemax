//
//  SignUpCredentialVC.swift
//  Cinemax
//
//  Created by IPS-161 on 29/01/24.
//

import UIKit
import RxCocoa
import RxSwift
import RxRelay
import SwiftUI

protocol SignUpCredentialVCProtocol: class {
    func setupInputs()
    func setUpBinding()
    func errorMsg(message:String)
    func successMsg(message:String)
}

class SignUpCredentialVC: UIViewController {
    
    @IBOutlet weak var firstNameTxtFld: UITextField!
    @IBOutlet weak var lastNameTxtFld: UITextField!
    @IBOutlet weak var phoneNumberTxtFld: UITextField!
    @IBOutlet weak var dateOfBirthTxtFld: UITextField!
    @IBOutlet weak var genderTxtFld: UITextField!
    @IBOutlet weak var emailaddressTxtFld: UITextField!
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var firstNameTxtFldView: RoundedCornerView!
    @IBOutlet weak var lastNameTxtFldView: RoundedCornerView!
    @IBOutlet weak var phoneNumberTxtFldView: RoundedCornerView!
    @IBOutlet weak var dateOfBirthTxtFldView: RoundedCornerView!
    @IBOutlet weak var genderTxtFldView: RoundedCornerView!
    @IBOutlet weak var emailaddressTxtFldView: RoundedCornerView!
    @IBOutlet weak var passwordTxtFldView: RoundedCornerView!
    @IBOutlet weak var passwordShowHideBtn: UIButton!
    @IBOutlet weak var privacyAndPolicyBtn: UIButton!
    @IBOutlet weak var termsANdConditionLblView: UIView!
    @IBOutlet weak var signUpBtn: RoundedButton!
    
    var presenter : SignUpCredentialVCPresenterProtocol?
    var presenterProducer : SignUpCredentialVCPresenterProtocol.Producer!
    var isPassworShow = false {
        didSet{
            passwordShowHideBtn.setImage(UIImage(named: isPassworShow ? "EyeBtnOpen" : "EyeBtnClose"), for: .normal)
            passwordTxtFld.isSecureTextEntry = isPassworShow ? false : true
        }
    }
    var isTermsAndConditionCheck = false {
        didSet{
            privacyAndPolicyBtn.setImage(UIImage(systemName: isTermsAndConditionCheck ? "checkmark.square" : "square"), for: .normal)
        }
    }
    var isTermsAndConditionCheckDriver: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var doSignUp: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    private let genderOptions = ["Male", "Female"]
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInputs()
        presenter?.viewDidload()
    }
    
    func backBtnPressed(){
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func passwordShowHideBtnPressed(_ sender: UIButton) {
        isPassworShow.toggle()
    }
    
    @IBAction func privacyAndPolicyBtnPressed(_ sender: UIButton) {
        isTermsAndConditionCheck.toggle()
        isTermsAndConditionCheckDriver.accept(isTermsAndConditionCheck)
    }
    
    
    @IBAction func signUpBtnPressed(_ sender: UIButton) {
        if(doSignUp.value){
            makeSignupProcess()
        }else{
            showErrors()
        }
    }
    
}

extension SignUpCredentialVC: SignUpCredentialVCProtocol {
    
    func setupInputs() {
        presenter = presenterProducer((
            email: emailaddressTxtFld.rx.text.orEmpty.asDriver(),
            password: passwordTxtFld.rx.text.orEmpty.asDriver(),
            firstName: firstNameTxtFld.rx.text.orEmpty.asDriver(),
            lastName: lastNameTxtFld.rx.text.orEmpty.asDriver(),
            genderName: genderTxtFld.rx.text.orEmpty.asDriver(),
            isTermsAndConditionAccept: isTermsAndConditionCheckDriver.asDriver()
        ))
        setupBirthDatePicker()
        setupGenderPicker()
        phoneNumberTxtFld.delegate = self
        firstNameTxtFld.addTarget(self, action: #selector(textFieldDidChangeForFirstNameTxtFld(_:)), for: .editingChanged)
        lastNameTxtFld.addTarget(self, action: #selector(textFieldDidChangeForLastNameTxtFld(_:)), for: .editingChanged)
        phoneNumberTxtFld.addTarget(self, action: #selector(textFieldDidChangeForPhoneNumberTxtFld(_:)), for: .editingChanged)
        genderTxtFld.addTarget(self, action: #selector(textFieldDidChangeForGenderTxtFld(_:)), for: .editingDidEnd)
        emailaddressTxtFld.addTarget(self, action: #selector(textFieldDidChangeForEmailAddressTxtFld(_:)), for: .editingChanged)
        passwordTxtFld.addTarget(self, action: #selector(textFieldDidChangeForPasswordTxtFld(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChangeForFirstNameTxtFld(_ textField: UITextField) {
        firstNameTxtFldView.borderColor = UIColor.appBlue!
    }
    @objc func textFieldDidChangeForLastNameTxtFld(_ textField: UITextField) {
        lastNameTxtFldView.borderColor = UIColor.appBlue!
    }
    @objc func textFieldDidChangeForPhoneNumberTxtFld(_ textField: UITextField) {
        phoneNumberTxtFldView.borderColor = UIColor.appBlue!
    }
    @objc func textFieldDidChangeForGenderTxtFld(_ textField: UITextField) {
        genderTxtFldView.borderColor = UIColor.appBlue!
    }
    @objc func textFieldDidChangeForEmailAddressTxtFld(_ textField: UITextField) {
        emailaddressTxtFldView.borderColor = UIColor.appBlue!
    }
    @objc func textFieldDidChangeForPasswordTxtFld(_ textField: UITextField) {
        passwordTxtFldView.borderColor = UIColor.appBlue!
    }
    
    
    func setupBirthDatePicker(){
        let birthDatePicker = UIDatePicker()
        birthDatePicker.datePickerMode = .date
        birthDatePicker.maximumDate = Date() // Set maximum date to the current date
        birthDatePicker.addTarget(self, action: #selector(dateChange(birthDatePicker:)), for: .valueChanged)
        birthDatePicker.frame.size = CGSize(width: 0, height: 300)
        birthDatePicker.preferredDatePickerStyle = .wheels
        dateOfBirthTxtFld.inputView = birthDatePicker
    }
    
    @objc func dateChange(birthDatePicker:UIDatePicker){
        dateOfBirthTxtFld.text = formatDate(date: birthDatePicker.date)
    }
    
    func formatDate(date:Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd yyy"
        return formatter.string(from: date)
    }
    
    
    func setUpBinding(){
        presenter?.output.enableLogin
            .debug("Enable Login Driver", trimOutput: false)
            .drive { [weak self] enableLogin in
                self?.doSignUp.accept(enableLogin)
            }
            .disposed(by: bag)
    }
    
    func makeSignupProcess(){
        if !(phoneNumberTxtFld.text!.isEmpty){
            if (phoneNumberTxtFld.text!.isPhoneNumberValid()){
                doSignup()
            }else{
                let alertMsg = getErrorsMsg(errors: SignUpCredentialVCErrors.phoneNumberTxtFldError)
                self.alertMsg(message:alertMsg)
                showErrorVisuals(errors: SignUpCredentialVCErrors.phoneNumberTxtFldError)
            }
        }else{
            doSignup()
        }
    }
    
    func doSignup(){
        presenter?.signUp(firstName: firstNameTxtFld.text, lastName: lastNameTxtFld.text, phoneNumber: phoneNumberTxtFld.text, gender: genderTxtFld.text, dateOfBirth: dateOfBirthTxtFld.text, email: emailaddressTxtFld.text, password: passwordTxtFld.text)
    }
    
    func showErrors(){
        if (firstNameTxtFld.text!.isEmpty) &&
            (lastNameTxtFld.text!.isEmpty) &&
            (genderTxtFld.text!.isEmpty) &&
            (emailaddressTxtFld.text!.isEmpty) &&
            (passwordTxtFld.text!.isEmpty) &&
            (!isTermsAndConditionCheck){
            showAllErrorVisuals()
            alertMsg(message: "Please fill all required fields and accept terms and condition first.")
        }else if !(firstNameTxtFld.text!.isValidName()) {
            if(firstNameTxtFld.text!.isEmpty){
                alertMsg(message:"Fill First name.")
            }else{
                let alertMsg = getErrorsMsg(errors: SignUpCredentialVCErrors.firstNameTxtFldError)
                self.alertMsg(message:alertMsg)
            }
            showErrorVisuals(errors: SignUpCredentialVCErrors.firstNameTxtFldError)
        }else if !(lastNameTxtFld.text!.isValidName()){
            if(lastNameTxtFld.text!.isEmpty){
                alertMsg(message:"Fill Last name.")
            }else{
                let alertMsg = getErrorsMsg(errors: SignUpCredentialVCErrors.lastNameTxtFldError)
                self.alertMsg(message:alertMsg)
            }
            showErrorVisuals(errors: SignUpCredentialVCErrors.lastNameTxtFldError)
        }else if(genderTxtFld.text!.isEmpty){
            let alertMsg = getErrorsMsg(errors: SignUpCredentialVCErrors.genderTxtFldError)
            self.alertMsg(message:alertMsg)
            showErrorVisuals(errors: SignUpCredentialVCErrors.genderTxtFldError)
        }else if !(emailaddressTxtFld.text!.isEmailValid()){
            if(emailaddressTxtFld.text!.isEmpty){
                alertMsg(message:"Fill Email address.")
            }else{
                let alertMsg = getErrorsMsg(errors: SignUpCredentialVCErrors.emailaddressTxtFldError)
                self.alertMsg(message:alertMsg)
            }
            showErrorVisuals(errors: SignUpCredentialVCErrors.emailaddressTxtFldError)
        }else if !(passwordTxtFld.text!.isPasswordValid()){
            if(passwordTxtFld.text!.isEmpty){
                alertMsg(message:"Fill Password.")
            }else{
                let alertMsg = getErrorsMsg(errors: SignUpCredentialVCErrors.passwordTxtFldError)
                self.alertMsg(message:alertMsg)
            }
            showErrorVisuals(errors: SignUpCredentialVCErrors.passwordTxtFldError)
        }else if !(isTermsAndConditionCheck){
            let alertMsg = getErrorsMsg(errors: SignUpCredentialVCErrors.allTermsAndCondition)
            self.alertMsg(message:alertMsg)
        }
    }
    
    func getErrorsMsg(errors:SignUpCredentialVCErrors) -> String {
        switch errors {
        case .firstNameTxtFldError:
            return "First Name should not contain digits, symbols, and blank spaces."
        case .lastNameTxtFldError:
            return "Last Name should not contain digits, symbols, and blank spaces."
        case .genderTxtFldError:
            return "Fill Gender."
        case .emailaddressTxtFldError:
            return "Fill email in correct format."
        case .passwordTxtFldError:
            return "Password should be 6 characters and contain at least one alphabet, one integer, and one symbol."
        case .allTermsAndCondition:
            return "Please accept terms and condition."
        case .phoneNumberTxtFldError:
            return "The phone number can be empty or should consist of seven to ten digits."
        }
    }
    
    func showErrorVisuals(errors:SignUpCredentialVCErrors){
        switch errors {
        case .firstNameTxtFldError:
            firstNameTxtFldView.borderColor = .red
            firstNameTxtFld.shake(duration: 0.07, repeatCount: 4, autoreverses: true)
        case .lastNameTxtFldError:
            lastNameTxtFldView.borderColor = .red
            lastNameTxtFld.shake(duration: 0.07, repeatCount: 4, autoreverses: true)
        case .genderTxtFldError:
            genderTxtFldView.borderColor = .red
            genderTxtFld.shake(duration: 0.07, repeatCount: 4, autoreverses: true)
        case .emailaddressTxtFldError:
            emailaddressTxtFldView.borderColor = .red
            emailaddressTxtFld.shake(duration: 0.07, repeatCount: 4, autoreverses: true)
        case .passwordTxtFldError:
            passwordTxtFldView.borderColor = .red
            passwordTxtFld.shake(duration: 0.07, repeatCount: 4, autoreverses: true)
        case .allTermsAndCondition:
            print("")
        case .phoneNumberTxtFldError:
            phoneNumberTxtFldView.borderColor = .red
            phoneNumberTxtFld.shake(duration: 0.07, repeatCount: 4, autoreverses: true)
        }
    }
    
    func showAllErrorVisuals(){
        firstNameTxtFldView.borderColor = .red
        firstNameTxtFld.shake(duration: 0.07, repeatCount: 4, autoreverses: true)
        lastNameTxtFldView.borderColor = .red
        lastNameTxtFld.shake(duration: 0.07, repeatCount: 4, autoreverses: true)
        genderTxtFldView.borderColor = .red
        genderTxtFld.shake(duration: 0.07, repeatCount: 4, autoreverses: true)
        emailaddressTxtFldView.borderColor = .red
        emailaddressTxtFld.shake(duration: 0.07, repeatCount: 4, autoreverses: true)
        passwordTxtFldView.borderColor = .red
        passwordTxtFld.shake(duration: 0.07, repeatCount: 4, autoreverses: true)
    }
    
    
    func errorMsg(message:String){
        let customPopVC = CustomPopupVCBuilder.build(customPopupVCInputs: CustomPopupVCInputs.error, popupLblHeadlineInput: "Error!", popupSubheadlineInput: message)
        customPopVC.modalPresentationStyle = .overCurrentContext
        navigationController?.present(customPopVC,animated: true)
    }
    
    func alertMsg(message:String){
        let customPopVC = CustomPopupVCBuilder.build(customPopupVCInputs: CustomPopupVCInputs.alert, popupLblHeadlineInput: "Alert!", popupSubheadlineInput: message)
        customPopVC.modalPresentationStyle = .overCurrentContext
        navigationController?.present(customPopVC,animated: true)
    }
    
    func successMsg(message:String){
        let customPopVC = CustomPopupVCBuilder.build(customPopupVCInputs: CustomPopupVCInputs.success, popupLblHeadlineInput: "Success", popupSubheadlineInput: message)
        customPopVC.modalPresentationStyle = .overCurrentContext
        navigationController?.present(customPopVC,animated: true)
        CustomPopupVCBuilder.okBtnTrigger = {
            DispatchQueue.main.asyncAfter(deadline: .now()+1){ [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}

extension SignUpCredentialVC:  UIPickerViewDelegate , UIPickerViewDataSource {
    
    func setupGenderPicker(){
        let genderPicker = UIPickerView()
        genderPicker.delegate = self
        genderPicker.dataSource = self
        genderPicker.frame.size = CGSize(width: 0, height: 150)
        genderPicker.showsSelectionIndicator = true
        genderTxtFld.inputView = genderPicker
    }
    
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderOptions.count
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTxtFld.text = genderOptions[row]
    }
    
}

extension SignUpCredentialVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == firstNameTxtFld ||
            textField == lastNameTxtFld ||
            textField == dateOfBirthTxtFld ||
            textField == genderTxtFld{
            return false
        }
        guard let currentText = textField.text else { return true }
        let newLength = currentText.count + string.count - range.length
        return newLength <= 10
    }
}

enum SignUpCredentialVCErrors {
    case firstNameTxtFldError
    case lastNameTxtFldError
    case genderTxtFldError
    case emailaddressTxtFldError
    case passwordTxtFldError
    case allTermsAndCondition
    case phoneNumberTxtFldError
}
