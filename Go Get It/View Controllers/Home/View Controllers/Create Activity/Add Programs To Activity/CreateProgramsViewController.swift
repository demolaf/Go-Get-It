//
//  CreateProgramsViewController.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 17/06/2023.
//

import Foundation
import UIKit

class CreateProgramsViewController: UIViewController {
    
    @IBOutlet weak var formView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        if let sheet = sheetPresentationController {
                sheet.detents = [
                    .custom { context in
                        return self.formView.frame.height
                    }
                ]
            sheet.preferredCornerRadius = 30
            }
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        print("Done button pressed")
        
        dismiss(animated: true)
    }
}
