//
//  WorkoutProgressViewController.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 29/06/2023.
//

import UIKit
import CoreData

class WorkoutProgressViewController: UIViewController {
    
    @IBOutlet weak var progressMessageTextLabel: UILabel!
    @IBOutlet weak var progressBar: CircularProgressBar!
    @IBOutlet weak var workoutsBodyView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var activity: ActivityMO!
    var dataController: DataController!
    var programsFRC: NSFetchedResultsController<ProgramMO>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupFetchedResultsController()
    }
    
    func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<ProgramMO> = ProgramMO.fetchRequest()
        let predicate = NSPredicate(format: "activity == %@", activity)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        programsFRC = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        programsFRC.delegate = self
        do {
            try programsFRC.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
}

extension WorkoutProgressViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setup() {
        setupNavigationBar()
        setupProgressBar()
        setupProgressMessageTextLabel()
        setupWorkoutsBodyView()
        setupTableView()
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(CustomTableViewHeaderFooter.self,
                                   forHeaderFooterViewReuseIdentifier: "CurrentWorkoutsSection")
        registerTableViewCells()
    }
    
    private func registerTableViewCells() {
        let activityTableViewCell = UINib(nibName: "ActivityTableViewCell",
                                  bundle: nil)
        self.tableView.register(activityTableViewCell,
                                forCellReuseIdentifier: "WorkoutsCell")
    }
    
    func setupNavigationBar() {
        let imageView = UIImageView()
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1/1).isActive = true
        imageView.image = ActivityType(rawValue: Int(activity.type))?.info.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white
        
        let text = activity.title ?? ""
        
        let titleRange = text.range(of: text)!
        
        let attributedString = NSMutableAttributedString(string: text)
        
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .medium)], range: NSRange(titleRange, in: text))
        
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
        
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(textLabel)
        
        navigationItem.titleView = stackView
        
        navigationController?.navigationBar.topItem?.backButtonDisplayMode = .minimal
        navigationController?.navigationBar.tintColor = .white
        
//        let appearance = UINavigationBarAppearance()
//        appearance.configureWithOpaqueBackground()
//        appearance.backgroundColor = Colors.activitiesBackground
//
//        navigationController?.navigationBar.standardAppearance = appearance
//        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    func setupWorkoutsBodyView() {
        workoutsBodyView.layer.cornerRadius = 30
        workoutsBodyView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func setupProgressMessageTextLabel() {
        let title = "Keep It Going! 💯"
        let subtitle = "Your workout is almost completed"
        
        let text = "\(title)\n\n\(subtitle)"
        
        let titleRange = text.range(of: title)!
        let subtitleRange = text.range(of: subtitle)!
        
        let attributedString = NSMutableAttributedString(string: text)
        
        attributedString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .semibold), NSAttributedString.Key.foregroundColor: UIColor.white], range: NSRange(titleRange, in: text))
        
        attributedString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .light), NSAttributedString.Key.foregroundColor: UIColor.white], range: NSRange(subtitleRange, in: text))
        
        progressMessageTextLabel.attributedText = attributedString
        progressMessageTextLabel.numberOfLines = 0
    }
    
    private func setupProgressBar() {
        //
        let percentFormatter = NumberFormatter()
        percentFormatter.numberStyle = NumberFormatter.Style.percent
        percentFormatter.multiplier = 1
        percentFormatter.maximumFractionDigits = 0
        
        //
        let number = "70"
        let percentText = "%"
        
        let text = percentFormatter.string(from: Int(number)! as NSNumber)!
        
        let numberRange = number.range(of: number)!
        let percentRange = text.range(of: percentText)!
        
        let attributedString = NSMutableAttributedString(string: text)
        
        attributedString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium), NSAttributedString.Key.foregroundColor: UIColor.gray], range: NSRange(percentRange, in: text))
        
        attributedString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 40, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.white], range: NSRange(numberRange, in: text))
        
        progressBar.label.attributedText = attributedString
        
        //
        progressBar.thumbLayer.strokeColor = UIColor.green.cgColor
        progressBar.trackLayer.strokeColor = UIColor.black.cgColor
        
        //
        progressBar.setProgress(to: 0.7, animate: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if programsFRC.fetchedObjects?.isEmpty ?? false {
            tableView.setEmptyView(title: "You haven't created any programs yet.", message: "Create programs using the \"+\" button at the bottom")
        }
        else {
            tableView.restore()
        }
        return programsFRC.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        tableView.sectionHeaderTopPadding = 0
        
        guard (programsFRC?.sections?[section]) != nil else {
            return UIView()
        }
        
        if !(programsFRC.fetchedObjects?.isEmpty ?? false) {
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CurrentWorkoutsSection") as! CustomTableViewHeaderFooter

            let text = "Programs"
            let titleRange = text.range(of: text)!
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)], range: NSRange(titleRange, in: text))
            view.title.attributedText = attributedString

            return view
        }

        return UIView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutsCell") as! ActivityTableViewCell
        
        let program = programsFRC.object(at: indexPath)
        
        let activityType = ActivityType(rawValue: Int(program.activityType))!
        cell.imageCircleView.backgroundColor = activityType.info.color
        cell.programImageView.image = activityType.info.image
        cell.programTitleLabel.text = program.title
        cell.programSubtitleLabel.text = "\(program.reps) reps x \(program.sets) sets"
        // cell.markAsCompleted(completed: program.completed)
        
        return cell
    }
}

extension WorkoutProgressViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
            break
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            break
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        @unknown default:
            fatalError()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert:
            tableView.insertSections(indexSet, with: .fade)
        case .delete: tableView.deleteSections(indexSet, with: .fade)
        case .update, .move:
            fatalError("Invalid change type in controller(_:didChange:atSectionIndex:for:). Only .insert or .delete should be possible.")
        @unknown default:
            fatalError()
        }
    }

    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
}
