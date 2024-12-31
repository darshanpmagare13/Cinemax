//
//  OnboardingVCPresenter.swift
//  Cinemax
//
//  Created by IPS-161 on 24/01/24.
//

import Foundation

protocol OnboardingVCPresenterProtocol {
    func viewDidload()
    func loadOnboardingData(completion:@escaping()->())
    func onboardingDone()
    var datasource : [OnboardingVCEntity] { get set }
    func goToLoginVC()
}

class OnboardingVCPresenter {
    weak var view: OnboardingVCProtocol?
    var interactor: OnboardingVCInteractorProtocol
    var router: OnboardingVCRouterProtocol
    var datasource = [OnboardingVCEntity]()
    init(view: OnboardingVCProtocol,interactor: OnboardingVCInteractorProtocol,router: OnboardingVCRouterProtocol){
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension OnboardingVCPresenter: OnboardingVCPresenterProtocol {
  
    
    func viewDidload() {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            self?.loadOnboardingData{
                DispatchQueue.main.async { [weak self] in
                    self?.view?.updateUI()
                }
            }
        }
    }
    
    func loadOnboardingData(completion:@escaping()->()){
        Task {
            do {
                let onboardingData = try await interactor.loadOnboardingData()
                datasource = onboardingData
                completion()
            } catch {
                print("Failed to load onboarding data:", error)
                completion()
            }
        }
    }
    
    func onboardingDone(){
        UserdefaultRepositoryManager.storeUserInfoFromUserdefault(type: .isOnboardingDone, data: "true") { bool in
            print(bool)
        }
    }
    
    func goToLoginVC(){
        router.goToLoginVC()
    }
    
}
