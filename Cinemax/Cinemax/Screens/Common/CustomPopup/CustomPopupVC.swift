//
//  CustomPopupVC.swift
//  Cinemax
//
//  Created by IPS-177  on 22/04/24.
//

import UIKit


enum CustomPopupVCInputs{
    case success
    case asking
    case alert
    case error
    case suggestion
}

class CustomPopupVC: UIViewController {
    
    @IBOutlet weak var popupImg: UIImageView!
    @IBOutlet weak var popupLblHeadline: UILabel!
    @IBOutlet weak var popupSubheadline: UILabel!
    @IBOutlet weak var popupOkBtnView: UIView!
    @IBOutlet weak var popupYesNoBtnView: UIView!
    
    var customPopupVCInputs : CustomPopupVCInputs?
    var popupLblHeadlineInput : String?
    var popupSubheadlineInput: String?
    var okBtnTrigger : (()->())?
    var yesBtnTrigger : (()->())?
    var noBtnTrigger : (()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popupOkBtnView.isHidden = true
        popupYesNoBtnView.isHidden = true
        setupPopup()
    }
    
    
    @IBAction func okBtnPressed(_ sender: UIButton) {
        dismiss(animated: true)
        okBtnTrigger?()
    }
    
    @IBAction func yesBtnPressed(_ sender: UIButton) {
        dismiss(animated: true)
        yesBtnTrigger?()
    }
    
    
    @IBAction func noBtnPressed(_ sender: UIButton) {
        dismiss(animated: true)
        noBtnTrigger?()
    }
    
}

extension CustomPopupVC {
    func setupPopup(){
        if let popupLblHeadlineInput = popupLblHeadlineInput ,
           let popupSubheadlineInput = popupSubheadlineInput,
           let customPopupVCInputs = customPopupVCInputs {
            popupLblHeadline.text = popupLblHeadlineInput
            popupSubheadline.text = popupSubheadlineInput
            switch customPopupVCInputs {
            case.success:
                popupOkBtnView.isHidden = false
                popupYesNoBtnView.isHidden = true
                popupImg.image = UIImage(named: "PopupTick")
            case.asking:
                popupOkBtnView.isHidden = true
                popupYesNoBtnView.isHidden = false
                popupImg.image = UIImage(named: "PopupQuestionmark")
            case .alert:
                popupOkBtnView.isHidden = false
                popupYesNoBtnView.isHidden = true
                popupImg.image = UIImage(named: "popupAlert")
            case .error:
                popupOkBtnView.isHidden = false
                popupYesNoBtnView.isHidden = true
                popupImg.image = UIImage(named: "popupError")
            case .suggestion:
                popupOkBtnView.isHidden = false
                popupYesNoBtnView.isHidden = true
                popupImg.image = UIImage(named: "popupSuggestion")
            }
        }
    }
}
