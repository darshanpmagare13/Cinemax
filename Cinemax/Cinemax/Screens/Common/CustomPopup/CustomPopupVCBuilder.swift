//
//  CustomPopupVCBuilder.swift
//  Cinemax
//
//  Created by IPS-177  on 22/04/24.
//

import Foundation
import UIKit

public final class CustomPopupVCBuilder {
    static var okBtnTrigger : (()->())?
    static var yesBtnTrigger : (()->())?
    static var noBtnTrigger : (()->())?
    static func build(customPopupVCInputs:CustomPopupVCInputs,
                      popupLblHeadlineInput : String?,
                      popupSubheadlineInput: String?) -> UIViewController {
        let storyboard = UIStoryboard.Common
        let customPopupVC = storyboard.instantiateViewController(withIdentifier: "CustomPopupVC") as! CustomPopupVC
        customPopupVC.customPopupVCInputs = customPopupVCInputs
        customPopupVC.popupLblHeadlineInput = popupLblHeadlineInput
        customPopupVC.popupSubheadlineInput = popupSubheadlineInput
        customPopupVC.okBtnTrigger = {
            okBtnTrigger?()
        }
        customPopupVC.yesBtnTrigger = {
            yesBtnTrigger?()
        }
        customPopupVC.noBtnTrigger = {
            noBtnTrigger?()
        }
        return customPopupVC
    }
}
