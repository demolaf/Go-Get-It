//
//  WorkoutStatsViewController.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 16/06/2023.
//

import Foundation
import UIKit

class WorkoutsViewController: UIViewController {

    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var listView: UIView!
    @IBOutlet weak var workoutsTableView: UITableView!
    
    var activityRepository: ActivityRepository!
    
    var incompleteWorkouts = [ActivityDataModel]()
    
    var completeWorkouts = [ActivityDataModel]()
    
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
        
//        navigationController?.navigationBar.standardAppearance.shadowColor = .clear
//        navigationController?.navigationBar.scrollEdgeAppearance?.shadowColor = .clear
//
        postInit()
    }
}

extension WorkoutsViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Move these methods into an extension
    
    func postInit() {
        activityRepository = (UIApplication.shared.delegate as! AppDelegate).repositoryProvider.activityRepository
        
        setupTableView()
        
        setupViewAppearance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchWorkoutActivities()
    }
    
    func fetchWorkoutActivities() {
        incompleteWorkouts = activityRepository.fetchWorkoutActivities(completed: false)
        completeWorkouts = activityRepository.fetchWorkoutActivities(completed: true)
        
        workoutsTableView.reloadData()
    }
    
    func setupTableView() {
        workoutsTableView.delegate = self
        workoutsTableView.dataSource = self
        
        workoutsTableView.register(CustomTableViewHeaderFooter.self,
                                   forHeaderFooterViewReuseIdentifier: "IncompleteSection")
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
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if incompleteWorkouts.isEmpty && completeWorkouts.isEmpty {
            tableView.setEmptyView(title: "No workouts yet.", message: "Create workouts using the \"Start New Activity\" buttons on the home screen")
        }
        else {
            tableView.restore()
        }
        
        if section == 0 {
            return incompleteWorkouts.count
        }
        
        return completeWorkouts.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            if !incompleteWorkouts.isEmpty {
                let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "IncompleteSection") as! CustomTableViewHeaderFooter
                
                let text = "Incomplete Workouts"
                let titleRange = text.range(of: text)!
                let attributedString = NSMutableAttributedString(string: text)
                attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)], range: NSRange(titleRange, in: text))
                view.title.attributedText = attributedString
                
                return view
            }
            return UIView()
        } else {
            if !completeWorkouts.isEmpty {
                let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CompleteSection") as! CustomTableViewHeaderFooter
                
                let text = "Complete Workouts"
                let titleRange = text.range(of: text)!
                let attributedString = NSMutableAttributedString(string: text)
                attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)], range: NSRange(titleRange, in: text))
                view.title.attributedText = attributedString
                
                return view
            }
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutsCell") as! ActivityTableViewCell
        
        if indexPath.section == 0 {
            let incompleteWorkout = incompleteWorkouts[indexPath.row]
            
            cell.programImageView.image = incompleteWorkout.activityType.info.image
            cell.imageCircleView.backgroundColor = incompleteWorkout.activityType.info.color
            cell.programTitleLabel.text = incompleteWorkout.activityTitle
            cell.programSubtitleLabel.text = "\(incompleteWorkout.programs.count) workouts left"
            
            return cell
        }
        
        let completeWorkout = completeWorkouts[indexPath.row]
        
        cell.programImageView.image = completeWorkout.activityType.info.image
        cell.imageCircleView.backgroundColor = completeWorkout.activityType.info.color
        cell.programTitleLabel.text = completeWorkout.activityTitle
        cell.programSubtitleLabel.text = "Completed"
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let workoutProgressVC = storyboard?.instantiateViewController(withIdentifier: "WorkoutProgressViewController") as! WorkoutProgressViewController
        
        if indexPath.section == 0 {
            workoutProgressVC.activity = incompleteWorkouts[indexPath.row]
        } else if indexPath.section == 1 {
            workoutProgressVC.activity = completeWorkouts[indexPath.row]
        }
        
        navigationController?.pushViewController(workoutProgressVC, animated: true)
    }
}
