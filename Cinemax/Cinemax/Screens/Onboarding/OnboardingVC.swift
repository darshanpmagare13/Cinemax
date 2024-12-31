//
//  OnboardingVC.swift
//  Cinemax
//
//  Created by IPS-161 on 24/01/24.
//

import UIKit
import JXPageControl

protocol OnboardingVCProtocol: class {
    func updateUI()
    func nextOnboarding()
}

class OnboardingVC: UIViewController {
    
    @IBOutlet weak var backgroundImg: UIImageView!
    @IBOutlet weak var frontImg: UIImageView!
    @IBOutlet weak var frontImgView: UIView!
    @IBOutlet weak var headlineLbl: UILabel!
    @IBOutlet weak var subHeadlineLbl: UILabel!
    @IBOutlet weak var pageControl: JXPageControlEllipse!
    
    var presenter: OnboardingVCPresenterProtocol?
    var onboardingScreenIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidload()
    }
    
    @IBAction func nxtBtnPressed(_ sender: UIButton) {
        nextOnboarding()
    }
    
}

extension OnboardingVC: OnboardingVCProtocol {
    
    func nextOnboarding(){
        guard onboardingScreenIndex < 2 else {
            presenter?.goToLoginVC()
            return
        }
        onboardingScreenIndex += 1
        updateUI()
        let progress = CGFloat(onboardingScreenIndex) / CGFloat(presenter?.datasource.count ?? 1)
        pageControl.progress = progress
        pageControl.currentPage = onboardingScreenIndex
        if onboardingScreenIndex == 2 {
            presenter?.onboardingDone()
        }
    }
    
    
    func updateUI(){
        guard let datasource = presenter?.datasource[onboardingScreenIndex] else {
            return
        }
        
        if onboardingScreenIndex == 0 {
            backgroundImg.isHidden = false
            frontImg.isHidden = true
            backgroundImg.image = datasource.img
        }else{
            UIView.transition(with: frontImg,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: {
                self.backgroundImg.isHidden = true
                self.frontImg.isHidden = false
                self.frontImg.image = datasource.img
                self.headlineLbl.text = datasource.headline
                self.subHeadlineLbl.text = datasource.subHeadline
            },completion: nil)
        }
    }
    
}


