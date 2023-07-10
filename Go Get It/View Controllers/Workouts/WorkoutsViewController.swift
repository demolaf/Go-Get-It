//
//  WorkoutStatsViewController.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 16/06/2023.
//

import Foundation
import UIKit
import CoreData

class WorkoutsViewController: UIViewController {
    
    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var listView: UIView!
    @IBOutlet weak var workoutsTableView: UITableView!
    
    var activityRepository: ActivityRepository!
    
    var workoutsFRC: NSFetchedResultsController<ActivityMO>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let text = "Workout"
        
        let titleRange = text.range(of: text)!
        
        let attributedString = NSMutableAttributedString(string: text)
        
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold)], range: NSRange(titleRange, in: text))
        
        let textLabel = UILabel()
        textLabel.attributedText  = attributedString
        textLabel.textAlignment = .center
        
        //Stack View
        let stackView   = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis  = NSLayoutConstraint.Axis.horizontal
        stackView.distribution  = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing = 12.0
        stackView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        stackView.addArrangedSubview(textLabel)
        
        navigationItem.titleView = stackView
        
        setup()
    }
}

extension WorkoutsViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Move these methods into an extension
    
    func setup() {
        activityRepository = (UIApplication.shared.delegate as! AppDelegate).repositoryProvider.activityRepository
        
        setupTableView()
        
        setupViewAppearance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchWorkoutActivities()
    }
    
    func fetchWorkoutActivities() {
        setupWorkoutsFetchedResultsController()
        
        workoutsTableView.reloadData()
    }
    
    func setupWorkoutsFetchedResultsController() {
        let fetchRequest:NSFetchRequest<ActivityMO> = ActivityMO.fetchRequest()
        
        let completedSortDescriptor = NSSortDescriptor(key: "completed", ascending: true)
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [completedSortDescriptor, sortDescriptor]
        
        workoutsFRC = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: activityRepository.dataController.viewContext, sectionNameKeyPath: "completed", cacheName: nil)
        workoutsFRC.delegate = self
        do {
            try workoutsFRC.performFetch()
            
            //TODO: this is here because if number of sections is set by FRC and there are no sections the function tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) will not be executed
            if (workoutsFRC.fetchedObjects?.isEmpty ?? false) {
                workoutsTableView.setEmptyView(title: "No workouts yet", message: "Create workouts using the \"Start New Activity\" buttons on the home screen")
            } else {
                workoutsTableView.restore()
            }
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    func setupTableView() {
        workoutsTableView.delegate = self
        workoutsTableView.dataSource = self
        
        workoutsTableView.register(CustomTableViewHeaderFooter.self,
                                   forHeaderFooterViewReuseIdentifier: "CompleteSection")
        
        registerTableViewCells()
    }
    
    private func registerTableViewCells() {
        let activityTableViewCell = UINib(nibName: "ActivityTableViewCell",
                                          bundle: nil)
        self.workoutsTableView.register(activityTableViewCell,
                                        forCellReuseIdentifier: "WorkoutsCell")
    }
    
    private func setupViewAppearance() {
        //
        bodyView.layer.cornerRadius = 30
        bodyView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        listView.layer.cornerRadius = 20
        listView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    // MARK: Reminders Delegate & Datasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return workoutsFRC.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workoutsFRC.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard (workoutsFRC?.sections?[section]) != nil else {
            return UIView()
        }
        
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CompleteSection") as! CustomTableViewHeaderFooter
        
        if section == 0 {
            let text = "Incomplete Workouts"
            let titleRange = text.range(of: text)!
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)], range: NSRange(titleRange, in: text))
            view.title.attributedText = attributedString
            
            return view
        }
        
        let text = "Complete Workouts"
        let titleRange = text.range(of: text)!
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)], range: NSRange(titleRange, in: text))
        view.title.attributedText = attributedString
        
        return view
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutsCell") as! ActivityTableViewCell
        
        guard let workout = self.workoutsFRC?.object(at: indexPath) else {
            fatalError("Attempt to configure cell without a managed object")
        }
        
        let activityType = ActivityType(rawValue: Int(workout.type))!
        cell.programImageView.image = activityType.info.image
        cell.imageCircleView.backgroundColor = activityType.info.color
        cell.programTitleLabel.text = workout.title
        cell.programSubtitleLabel.text =  workout.completed ? "Completed" : "\(workout.programs?.count ?? 0) workouts left"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let workoutProgressVC = storyboard?.instantiateViewController(withIdentifier: "WorkoutProgressViewController") as! WorkoutProgressViewController
        
        workoutProgressVC.activity =  workoutsFRC.object(at: indexPath)
        workoutProgressVC.dataController = self.activityRepository.dataController
        
        navigationController?.pushViewController(workoutProgressVC, animated: true)
    }
}

extension WorkoutsViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            workoutsTableView.insertRows(at: [newIndexPath!], with: .fade)
            break
        case .delete:
            workoutsTableView.deleteRows(at: [indexPath!], with: .fade)
            break
        case .update:
            workoutsTableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            workoutsTableView.moveRow(at: indexPath!, to: newIndexPath!)
        @unknown default:
            fatalError()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert: workoutsTableView.insertSections(indexSet, with: .fade)
        case .delete: workoutsTableView.deleteSections(indexSet, with: .fade)
        case .update, .move:
            fatalError("Invalid change type in controller(_:didChange:atSectionIndex:for:). Only .insert or .delete should be possible.")
        @unknown default:
            fatalError()
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        workoutsTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        workoutsTableView.endUpdates()
    }
    
}

