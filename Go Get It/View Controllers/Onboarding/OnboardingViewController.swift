//
//  ViewController.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 10/06/2023.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var onboardingImage: UIImageView!
    @IBOutlet weak var headerText: UILabel!
    @IBOutlet weak var subtitleText: UILabel!
    @IBOutlet weak var ctaButton: UIButton!
    @IBOutlet weak var onboardingPageControl: UIPageControl!
    
    var onboardingData: OnboardingData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }
    
    func setup() {
        onboardingPageControl.numberOfPages = 3
        onboardingPageControl.currentPage = onboardingData.currentPage
        
        view.layer.backgroundColor = onboardingData.backgroundColor.cgColor
        onboardingImage.image = onboardingData.image
        headerText.text = onboardingData.header
        subtitleText.text = onboardingData.subitle
        ctaButton.setTitle(onboardingData.buttonCTA, for: .normal)
        
    }
    
    @IBAction func skipButtonPressed(_ sender: UIButton) {
        let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        navigationController?.pushViewController(loginVC, animated: true)
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        
    }
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct OnboardingViewController_Preview: PreviewProvider {
    static var previews: some View {
        // view controller using programmatic UI
        // Assuming your storyboard file name is "Main"
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "OnboardingViewController").showPreview()
    }
}
#endif
