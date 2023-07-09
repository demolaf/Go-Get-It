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
    @IBOutlet weak var upperButton: UIView!
    @IBOutlet weak var armsButton: UIView!
    @IBOutlet weak var legsButton: UIView!
    @IBOutlet weak var cardioButton: UIView!
    @IBOutlet weak var yogaButton: UIView!
    
    @IBOutlet weak var programTitleTextField: UITextField!
    @IBOutlet weak var setsTextField: UITextField!
    @IBOutlet weak var repsTextField: UITextField!
    @IBOutlet weak var restTimeTextField: UITextField!
    @IBOutlet weak var totalTimeTextField: UITextField!
    
    //TODO: Default to using the selected activity type
    // when creating the activity
    var activityRepository: ActivityRepository!
    var activity: ActivityMO!
    var selectedCategoryActivityType: ActivityType!
    var dismissCompletionHandler: (() -> Void)!
    
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
        
        programTitleTextField.delegate = self
        setsTextField.delegate = self
        repsTextField.delegate = self
        restTimeTextField.delegate = self
        totalTimeTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupKeyboardNotifier()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeKeyboardNotifier()
    }
    
    @IBAction func categoryActivityButtonPressed(_ sender: UITapGestureRecognizer) {
        guard let tag = sender.view?.tag else {
            return
        }
        
        guard let activityType = ActivityType(rawValue: tag) else {
            return
        }
        
        updateCategoryIndicator(activityType)
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        guard let title = programTitleTextField.text, let sets = setsTextField.text, let reps = repsTextField.text, let restTime = restTimeTextField.text, let totalTime = totalTimeTextField.text
        else {
            return
        }
        
        activityRepository.createWorkoutProgram(activity, title: title, programActivityType: selectedCategoryActivityType ?? ActivityType(rawValue: Int(activity.type))!, sets: Int(sets) ?? 0, reps: Int(reps) ?? 0, restTime: Double(restTime) ?? 0, totalProgramTime: Double(totalTime) ?? 0)
        
        dismiss(animated: true, completion: dismissCompletionHandler)
    }
    
    private func updateCategoryIndicator(_ activityType: ActivityType) {
        if selectedCategoryActivityType == activityType {
            selectedCategoryActivityType = nil
        } else {
            // Select the category
            selectedCategoryActivityType = activityType
        }
        
        let buttons: [(UIView, ActivityType)] = [
            (upperButton, .upper),
            (armsButton, .arm),
            (legsButton, .legs),
            (cardioButton, .cardio),
            (yogaButton, .yoga)
        ]
        
        for (button, activityType) in buttons {
            let selected: Bool = selectedCategoryActivityType == activityType
            selectCategoryIndicator(button, selected: selected)
        }
    }
    
    private func selectCategoryIndicator(_ sender: UIView, selected: Bool) {
        if selected {
            sender.layer.borderWidth = 2
            sender.layer.borderColor = Colors.homeBackground?.cgColor
        } else {
            sender.layer.borderWidth = 0
            sender.layer.borderColor = UIColor.clear.cgColor
        }
    }
}

extension CreateProgramsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Hide keyboard setup
    
    func setupKeyboardNotifier() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardNotifier() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if restTimeTextField.isEditing || totalTimeTextField.isEditing {
            // move the root view up by the distance of keyboard height
            self.view.frame.origin.y = -self.getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
            // move back the root view origin to zero
            self.view.frame.origin.y = 0
        
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
}
