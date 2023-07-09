//
//  LoginViewController.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 13/06/2023.
//

import Foundation
import UIKit

enum AuthType: Int {
    case google = 0
    case facebook
}

class LoginViewController: UIViewController {
    var authenticationRepository: AuthenticationRepository!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        
        authenticationRepository = (UIApplication.shared.delegate as! AppDelegate).repositoryProvider.authRepository
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        if let authType = AuthType(rawValue: sender.tag) {
            login(authType: authType)
        }
    }
    
    func login(authType: AuthType) {
        switch authType {
        case .google:
            authenticationRepository.signInWithGoogle(vc: self) { success, error in
                if success {
                    self.navigateToHome()
                }
            }
        case .facebook:
            authenticationRepository.signInWithFacebook()
            navigateToHome()
        }
    }
    
    func navigateToHome() {
        let homeVC = storyboard?.instantiateViewController(withIdentifier: "MainTabViewController") as! MainTabViewController
        navigationController?.pushViewController(homeVC, animated: true)
    }
}
