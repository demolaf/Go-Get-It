//
//  HomeViewController.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 13/06/2023.
//

import Foundation
import UIKit
import CoreData

class HomeViewController: UIViewController {
    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var remindersTableView: UITableView!
    
    var remindersRepository: RemindersRepository!
    var activityRepository: ActivityRepository!
    var authenticationRepository: AuthenticationRepository!
    var remindersFRC: NSFetchedResultsController<ReminderMO>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        remindersRepository = (UIApplication.shared.delegate as! AppDelegate).repositoryProvider.remindersRepository
        activityRepository = (UIApplication.shared.delegate as! AppDelegate).repositoryProvider.activityRepository
        authenticationRepository = (UIApplication.shared.delegate as! AppDelegate).repositoryProvider.authRepository
        
        remindersTableView.delegate = self
        remindersTableView.dataSource = self
        
        setup()
        
        setupWorkoutsFetchedResultsController()
    }
    
    func setupWorkoutsFetchedResultsController() {
        let fetchRequest:NSFetchRequest<ReminderMO> = ReminderMO.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        remindersFRC = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: activityRepository.dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        remindersFRC.delegate = self
        do {
            try remindersFRC.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
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
    
    @IBAction func logout(_ sender: UIButton) {
        //TODO: navigate to onboarding on completion
        authenticationRepository.signOut()
        let onboardingPageVC = storyboard?.instantiateViewController(withIdentifier: "OnboardingPageViewController") as! OnboardingPageViewController
        navigationController?.pushViewController(onboardingPageVC, animated: true)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Move these methods into an extension
    
    func setup() {
        setupViewAppearance()
        setGreetingText()
    }
    
    private func setupViewAppearance() {
        //
        bodyView.layer.cornerRadius = 30
        bodyView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private func setGreetingText() {
        var title = ""
        
        if let authUserData = authenticationRepository.getAuthUserData() {
            title = "Hi \(authUserData.name.components(separatedBy: " ")[0])"
        } else {
            title = "Hi"
        }
        
        let subtitle = "Get pumped!"
        
        let greetingText = "\(title),\n\(subtitle)"
        
        let titleRange = greetingText.range(of: title)!
        
        let subtitleRange = greetingText.range(of: subtitle)!
        
        let attributedString = NSMutableAttributedString(string: greetingText)
        
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .light)], range: NSRange(titleRange, in: greetingText))
        
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: UIFont.Weight(600))], range: NSRange(subtitleRange, in: greetingText))
        
        self.headerLabel.attributedText = attributedString
        self.headerLabel.numberOfLines = 2
    }
    
    // MARK: Reminders Delegate & Datasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return remindersFRC.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (remindersFRC.fetchedObjects?.isEmpty ?? false) {
            remindersTableView.setEmptyView(title: "No reminders yet", message: "Create reminders using the \"+\" button at the corner")
        } else {
            remindersTableView.restore()
        }
        
        return remindersFRC.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RemindersCell") as! RemindersTableViewCell
        
        let reminder = remindersFRC.object(at: indexPath)
        
        cell.reminderLabel.text = reminder.title
        cell.checkbox.isSelected = reminder.completed
        
        cell.backgroundColor = .clear
        
        return cell
    }
}

extension HomeViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            remindersTableView.insertRows(at: [newIndexPath!], with: .fade)
            break
        case .delete:
            remindersTableView.deleteRows(at: [indexPath!], with: .fade)
            break
        case .update:
            remindersTableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            remindersTableView.moveRow(at: indexPath!, to: newIndexPath!)
        @unknown default:
            fatalError()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert:
            remindersTableView.insertSections(indexSet, with: .fade)
        case .delete: remindersTableView.deleteSections(indexSet, with: .fade)
        case .update, .move:
            fatalError("Invalid change type in controller(_:didChange:atSectionIndex:for:). Only .insert or .delete should be possible.")
        @unknown default:
            fatalError()
        }
    }
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        remindersTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        remindersTableView.endUpdates()
    }
    
}

