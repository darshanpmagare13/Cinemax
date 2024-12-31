//
//  ResetPasswordVC.swift
//  Cinemax
//
//  Created by IPS-161 on 29/01/24.
//

import UIKit
import RxSwift
import RxCocoa

protocol ResetPasswordVCPrtocol: class {
    func setUpBinding()
    func errorMsg(message:String)
    func successAlert(message:String)
}

class ResetPasswordVC: UIViewController {
    
    @IBOutlet weak var resetPasswordView: UIView!
    @IBOutlet weak var emailAddressTxtFld: UITextField!
    @IBOutlet weak var nxtBtn: RoundedButton!
    @IBOutlet weak var emailAddressTxtFldView: RoundedCornerView!
    
    var presenter : ResetPasswordVCPresenterProtocol?
    var presenterProducer : ResetPasswordVCPresenterProtocol.Producer!
    private let bag = DisposeBag()
    var doReset: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInputs()
        presenter?.viewDidload()
    }
    
    @IBAction func nxtBtnPressed(_ sender: UIButton) {
        if(doReset.value){
            resetPasswordRequest()
        }else{
            showErrors()
        }
    }
    
    func backBtnPressed() {
        navigationController?.popViewController(animated: true)
    }
}

extension ResetPasswordVC : ResetPasswordVCPrtocol {
    
    func setupInputs(){
        presenter = presenterProducer((
            email: emailAddressTxtFld.rx.text.orEmpty.asDriver(),()
        ))
    }
    
    func setUpBinding(){
        presenter?.output.enableReset
            .debug("Enable Login Driver", trimOutput: false)
            .drive { [weak self] enableReset in
                self?.doReset.accept(enableReset)
            }
            .disposed(by: bag)
    }
    
    func showErrors(){
        if !(emailAddressTxtFld.text!.isEmailValid()){
            if(emailAddressTxtFld.text!.isEmpty){
                alertMsg(message:"Fill Email.")
            }else{
                self.alertMsg(message:"Fill email in correct format.")
            }
            emailAddressTxtFldView.borderColor = .red
            emailAddressTxtFld.shake(duration: 0.07, repeatCount: 4, autoreverses: true)
        }
    }
    
    private func resetPasswordRequest(){
        presenter?.resetPasswordRequest(email: emailAddressTxtFld.text)
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
    
    func successAlert(message:String){
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
