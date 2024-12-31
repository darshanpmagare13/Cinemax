//
//  EditProfileVC.swift
//  Cinemax
//
//  Created by IPS-161 on 02/02/24.
//

import UIKit
import YPImagePicker
import RxSwift
import RxCocoa

protocol EditProfileVCProtocol : class {
    func setupInputs()
    func setUpBinding()
    func errorMsgAlert(error:String)
}

class EditProfileVC: UIViewController {
    
    @IBOutlet weak var currentUserName: UILabel!
    @IBOutlet weak var currentUserEmailLbl: UILabel!
    @IBOutlet weak var currentUserProfileImg: CircleImageView!
    @IBOutlet weak var saveChangesBtn: RoundedButton!
    @IBOutlet weak var firstNameTxtFld: UITextField!
    @IBOutlet weak var firstNameTxtFldView: RoundedCornerView!
    @IBOutlet weak var lastNameTxtFld: UITextField!
    @IBOutlet weak var lastNameTxtFldView: RoundedCornerView!
    @IBOutlet weak var phoneNumberTxtFld: UITextField!
    @IBOutlet weak var phoneNumberTxtFldView: RoundedCornerView!
    @IBOutlet weak var dateOfBirthTxtFld: UITextField!
    @IBOutlet weak var genderTxtFld: UITextField!
    @IBOutlet weak var genderTxtFldView: RoundedCornerView!
    
    var presenter : EditProfileVCPresenterProtocol?
    var userDataRepositoryManager: UserDataRepositoryManagerProtocol?
    var presenterProducer : EditProfileVCPresenterProtocol.Producer!
    var config = YPImagePickerConfiguration()
    var imgPicker = YPImagePicker()
    private let disposeBag = DisposeBag()
    private let genderOptions = ["Male", "Female"]
    var doUpdate: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userDataRepositoryManager = UserDataRepositoryManager.shared
        setupInputs()
        presenter?.viewDidload()
    }
    
    @IBAction func saveBtnPressed(_ sender: UIButton) {
        if(doUpdate.value){
            makeUpdateProcess()
        }else{
            showErrors()
        }
    }
    
    @IBAction func profileImgEditBtn(_ sender: UIButton) {
        presentImagePicker()
    }
    
}

extension EditProfileVC : EditProfileVCProtocol {
    
    func setupInputs(){
        setUpBinding()
        presenter = presenterProducer((
            firstName : firstNameTxtFld.rx.text.orEmpty.asDriver(),
            lastName : lastNameTxtFld.rx.text.orEmpty.asDriver(),
            genderName : genderTxtFld.rx.text.orEmpty.asDriver()
        ))
        setupGenderPicker()
        setupBirthDatePicker()
        phoneNumberTxtFld.delegate = self
        firstNameTxtFld.addTarget(self, action: #selector(textFieldDidChangeForFirstNameTxtFld(_:)), for: .editingChanged)
        lastNameTxtFld.addTarget(self, action: #selector(textFieldDidChangeForLastNameTxtFld(_:)), for: .editingChanged)
        phoneNumberTxtFld.addTarget(self, action: #selector(textFieldDidChangeForPhoneNumberTxtFld(_:)), for: .editingChanged)
        genderTxtFld.addTarget(self, action: #selector(textFieldDidChangeForGenderTxtFld(_:)), for: .editingDidEnd)
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
    
    
    func setUpBinding(){
        
        presenter?.output.enableUpdate
            .debug("Enable Login Driver", trimOutput: false)
            .drive { [weak self] enableUpdate in
                self?.doUpdate.accept(enableUpdate)
            }
            .disposed(by: disposeBag)
        
        
        userDataRepositoryManager?.userFirstName.subscribe { event in
            if let element = event.element {
                DispatchQueue.main.async { [weak self] in
                    self?.currentUserName.text = element
                    self?.firstNameTxtFld.text = element
                }
            }
        }.disposed(by: disposeBag)
        
        userDataRepositoryManager?.userLastName.subscribe { event in
            if let element = event.element {
                DispatchQueue.main.async { [weak self] in
                    self?.lastNameTxtFld.text = element
                }
            }
        }.disposed(by: disposeBag)
        
        userDataRepositoryManager?.userPhoneNumber.subscribe { event in
            if let element = event.element {
                DispatchQueue.main.async { [weak self] in
                    self?.phoneNumberTxtFld.text = element
                }
            }
        }.disposed(by: disposeBag)
        
        userDataRepositoryManager?.userDateOfBirth.subscribe { event in
            if let element = event.element {
                DispatchQueue.main.async { [weak self] in
                    self?.dateOfBirthTxtFld.text = element
                }
            }
        }.disposed(by: disposeBag)
        
        userDataRepositoryManager?.userGender.subscribe { event in
            if let element = event.element {
                DispatchQueue.main.async { [weak self] in
                    self?.genderTxtFld.text = element
                }
            }
        }.disposed(by: disposeBag)
        
        userDataRepositoryManager?.userProfileImageUrl.subscribe{ event in
            if let element = event.element {
                DispatchQueue.main.async { [weak self] in
                    self?.currentUserProfileImg.WebImageLoadingFactory(urlString: element, placeholder: "person.fill")
                }
            }
        }.disposed(by: disposeBag)
        
        
        userDataRepositoryManager?.userEmailAddress.subscribe{ event in
            if let element = event.element {
                DispatchQueue.main.async { [weak self] in
                    self?.currentUserEmailLbl.text = element
                }
            }
        }.disposed(by: disposeBag)
        
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
    
    func backBtnPressed(){
        navigationController?.popViewController(animated: true)
    }
    
    func presentImagePicker() {
        if let topViewController = UIApplication.topViewController() {
            if topViewController.presentedViewController is YPImagePicker {
                return
            }
        }
        imgPicker.didFinishPicking { [weak self] items, cancelled in
            for item in items {
                switch item {
                case .photo(let photo):
                    let image = photo.image
                    self?.currentUserProfileImg.image = image
                    self?.presenter?.saveCurrentUserImgToFirebaseStorageAndDatabase(image: image)
                case .video(let video):
                    break
                }
            }
            self?.dismiss(animated: true, completion: nil)
        }
        present(imgPicker, animated: true, completion: nil)
    }
    
    func makeUpdateProcess(){
        if !(phoneNumberTxtFld.text!.isEmpty){
            if (phoneNumberTxtFld.text!.isPhoneNumberValid()){
                doUpdateProcess()
            }else{
                let alertMsg = getErrorsMsg(errors: EditProfileVCErrors.phoneNumberTxtFldError)
                self.alertMsg(message:alertMsg)
                showErrorVisuals(errors: EditProfileVCErrors.phoneNumberTxtFldError)
            }
        }else{
            doUpdateProcess()
        }
    }
    
    func doUpdateProcess(){
        presenter?.updateCurrentuseerNameInDatabase(firstName: firstNameTxtFld.text, lastName: lastNameTxtFld.text, phoneNumber: phoneNumberTxtFld.text, gender: genderTxtFld.text, dateOfBirth: dateOfBirthTxtFld.text, completion:{})
    }
    
    func showErrors(){
        if(firstNameTxtFld.text!.isEmpty && lastNameTxtFld.text!.isEmpty && genderTxtFld.text!.isEmpty ){
            showAllErrorVisuals()
            alertMsg(message: "Please fill all required fields.")
        }else if !(firstNameTxtFld.text!.isValidName()) {
            if(firstNameTxtFld.text!.isEmpty){
                alertMsg(message:"Fill First name.")
            }else{
                let alertMsg = getErrorsMsg(errors: EditProfileVCErrors.firstNameTxtFldError)
                self.alertMsg(message:alertMsg)
            }
            showErrorVisuals(errors: EditProfileVCErrors.firstNameTxtFldError)
        }else if !(lastNameTxtFld.text!.isValidName()){
            if(lastNameTxtFld.text!.isEmpty){
                alertMsg(message:"Fill Last name.")
            }else{
                let alertMsg = getErrorsMsg(errors: EditProfileVCErrors.lastNameTxtFldError)
                self.alertMsg(message:alertMsg)
            }
            showErrorVisuals(errors: EditProfileVCErrors.lastNameTxtFldError)
        }else if(genderTxtFld.text!.isEmpty){
            let alertMsg = getErrorsMsg(errors: EditProfileVCErrors.genderTxtFldError)
            self.alertMsg(message:alertMsg)
            showErrorVisuals(errors: EditProfileVCErrors.genderTxtFldError)
        }
    }
    
    func getErrorsMsg(errors:EditProfileVCErrors) -> String {
        switch errors {
        case .firstNameTxtFldError:
            return "First Name should not contain digits, symbols, and blank spaces."
        case .lastNameTxtFldError:
            return "Last Name should not contain digits, symbols, and blank spaces."
        case .genderTxtFldError:
            return "Fill Gender."
        case .phoneNumberTxtFldError:
            return "The phone number can be empty or should consist of seven to ten digits."
        }
    }
    
    func showErrorVisuals(errors:EditProfileVCErrors){
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
    }
    
    func errorMsgAlert(error:String){
        let popupLblHeadlineInput = "Error"
        let popupSubheadlineInput = error
        let customPopVC = CustomPopupVCBuilder.build(customPopupVCInputs: CustomPopupVCInputs.success, popupLblHeadlineInput: popupLblHeadlineInput, popupSubheadlineInput: popupSubheadlineInput)
        customPopVC.modalPresentationStyle = .overCurrentContext
        navigationController?.present(customPopVC,animated: true)
        CustomPopupVCBuilder.okBtnTrigger = {
            
        }
    }
    
    func alertMsg(message:String){
        let customPopVC = CustomPopupVCBuilder.build(customPopupVCInputs: CustomPopupVCInputs.alert, popupLblHeadlineInput: "Alert!", popupSubheadlineInput: message)
        customPopVC.modalPresentationStyle = .overCurrentContext
        navigationController?.present(customPopVC,animated: true)
    }
    
}

extension EditProfileVC:  UIPickerViewDelegate , UIPickerViewDataSource {
    
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

extension EditProfileVC: UITextFieldDelegate {
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

enum EditProfileVCErrors {
    case firstNameTxtFldError
    case lastNameTxtFldError
    case genderTxtFldError
    case phoneNumberTxtFldError
}
