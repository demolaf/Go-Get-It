//
//  HomeViewController.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 13/06/2023.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var remindersTableView: UITableView!
    
    var remindersRepository: RemindersRepository!
    var activityRepository: ActivityRepository!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        remindersTableView.delegate = self
        remindersTableView.dataSource = self
        
        postInit()
        
        remindersRepository = (UIApplication.shared.delegate as! AppDelegate).repositoryProvider.remindersRepository
        activityRepository = (UIApplication.shared.delegate as! AppDelegate).repositoryProvider.activityRepository
    }
    
    @IBAction func startActivityButtonPressed(_ sender: UITapGestureRecognizer) {
        guard let tag = sender.view?.tag else {
            return
        }
        
        print("Start activity \(tag)")
        
        let createActivityVC = storyboard?.instantiateViewController(withIdentifier: "CreateActivityViewController") as! CreateActivityViewController
        
        createActivityVC.activityType = ActivityType(rawValue: tag)
        createActivityVC.activityRepository = activityRepository
        createActivityVC.dismissCompletionHander = { newActivity in
            let addProgramsToActivityVC = self.storyboard?.instantiateViewController(withIdentifier: "AddProgramsToActivityViewController") as! AddProgramsToActivityViewController
            
            addProgramsToActivityVC.activity = newActivity
            addProgramsToActivityVC.activityRepository = self.activityRepository
            
            self.navigationController?.pushViewController(addProgramsToActivityVC, animated: true)
        }
        
        present(createActivityVC, animated: true)
    }
    
    @IBAction func addReminderButtonPressed(_ sender: UIButton) {
        let createReminderVC = storyboard?.instantiateViewController(withIdentifier: "CreateReminderViewController") as! CreateReminderViewController
        
        createReminderVC.remindersRepository = remindersRepository
        createReminderVC.dismissCompletionHandler = {
            self.remindersTableView.reloadData()
        }

        present(createReminderVC, animated: true)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Move these methods into an extension
    
    func postInit() {
        setupViewAppearance()
        setGreetingText()
    }
    
    private func setupViewAppearance() {
        //
        bodyView.layer.cornerRadius = 30
        bodyView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private func setGreetingText() {
        let title = "Hi Ademola"
        let subtitle = "Get pumped!"
        
        let greetingText = "\(title),\n\(subtitle)"
        
        let titleRange = greetingText.range(of: title)!

        let subtitleRange = greetingText.range(of: subtitle)!
        
        let attributedString = NSMutableAttributedString(string: greetingText)
        
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .light)], range: NSRange(titleRange, in: greetingText))
        
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: UIFont.Weight(600))], range: NSRange(subtitleRange, in: greetingText))
        
        headerLabel.attributedText = attributedString
        headerLabel.numberOfLines = 2
    }
    
    // MARK: Reminders Delegate & Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if remindersRepository.reminders.isEmpty {
            tableView.setEmptyView(title: "No reminders yet.", message: "Create reminders using the \"+\" button at the corner")
        }
        else {
            tableView.restore()
        }
        
        return remindersRepository.reminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RemindersCell") as! RemindersTableViewCell
        
        let reminder = remindersRepository.reminders[indexPath.row]
        
        cell.reminderLabel.text = reminder.reminderTitle
        cell.checkbox.isSelected = reminder.completed
        
        cell.backgroundColor = .clear
        
        return cell
    }
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct HomeViewController_Preview: PreviewProvider {
    static var previews: some View {
        // view controller using programmatic UI
        // Assuming your storyboard file name is "Main"
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "HomeViewController").showPreview()
    }
}
#endif
