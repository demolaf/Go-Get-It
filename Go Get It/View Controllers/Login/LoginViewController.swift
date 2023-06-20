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
    case apple
    case facebook
}

class LoginViewController: UIViewController {
    var authenticationRepository: AuthenticationRepository!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        
        authenticationRepository = AuthenticationRepositoryImpl()
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
        case .apple:
            authenticationRepository.signInWithApple()
        case .facebook:
            authenticationRepository.signInWithFacebook()
        }
    }
    
    func navigateToHome() {
        let homeVC = storyboard?.instantiateViewController(withIdentifier: "MainTabViewController") as! MainTabViewController
        navigationController?.pushViewController(homeVC, animated: true)
    }
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct LoginViewController_Preview: PreviewProvider {
    static var previews: some View {
        // view controller using programmatic UI
        // Assuming your storyboard file name is "Main"
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "LoginViewController").showPreview()
    }
}
#endif
