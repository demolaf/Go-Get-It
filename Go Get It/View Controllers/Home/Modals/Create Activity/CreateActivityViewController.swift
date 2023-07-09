//
//  CreateActivityViewController.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 16/06/2023.
//

import Foundation
import UIKit

class CreateActivityViewController: UIViewController {
    
    @IBOutlet weak var formView: UIView!
    @IBOutlet weak var workoutNameTextField: UITextField!
    @IBOutlet weak var activityImageView: UIImageView!
    @IBOutlet weak var activityCircleView: CircleView!
    @IBOutlet weak var activityLabelView: UILabel!
    
    var activityType: ActivityType!
    var activityRepository: ActivityRepository!
    var dismissCompletionHander: ((ActivityMO) -> Void)!
    
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
        
        //
        activityCircleView.backgroundColor = activityType.info.color
        activityLabelView.text = activityType.info.name
        activityImageView.image = activityType.info.image
        
        //
        workoutNameTextField.delegate = self
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        print("Continue button pressed")
        guard let text = workoutNameTextField.text, self.workoutNameTextField.hasText else {
            return
        }
        
        let newActivity = activityRepository.createWorkoutActivity(activityTitle: text, activityType: activityType)
        
        //TODO: Try to figure out how to lift the dismiss function to the parentVC
        // this might avoid having to pass the navigationController here
        dismiss(animated: true) {
            self.dismissCompletionHander(newActivity)
        }
    }
}

extension CreateActivityViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 15
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)

        return newString.count <= maxLength
    }
}
