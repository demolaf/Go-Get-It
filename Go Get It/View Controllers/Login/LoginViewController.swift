//
//  LoginViewController.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 13/06/2023.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
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
