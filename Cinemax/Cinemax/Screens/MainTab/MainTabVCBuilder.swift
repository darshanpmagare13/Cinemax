//
//  MainTabVCBuilder.swift
//  Cinemax
//
//  Created by IPS-161 on 24/01/24.
//

import Foundation
import UIKit

public final class MainTabVCBuilder {
    static func build() -> UIViewController {
        let storyboard = UIStoryboard.MainTab
        let mainTabVC = storyboard.instantiateViewController(withIdentifier: "MainTabVC") as! MainTabVC
        return mainTabVC
    }
}
