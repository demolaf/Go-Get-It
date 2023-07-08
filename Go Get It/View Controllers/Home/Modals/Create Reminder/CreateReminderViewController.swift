//
//  CreateReminderViewController.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 17/06/2023.
//

import Foundation
import UIKit

class CreateReminderViewController: UIViewController {
    
    @IBOutlet weak var formView: UIView!
    @IBOutlet weak var reminderTextField: UITextField!
    @IBOutlet weak var reminderSwitch: UISwitch!
    
    var remindersRepository: RemindersRepository!
    var dismissCompletionHandler: (() -> Void)?
    
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
        guard let title = reminderTextField.text else {
            return
        }
        
        remindersRepository.createReminder(title: title, time: nil, notifyMe: reminderSwitch.isOn, completed: false)
        
        dismiss(animated: true, completion: dismissCompletionHandler)
    }
}

extension CreateReminderViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
