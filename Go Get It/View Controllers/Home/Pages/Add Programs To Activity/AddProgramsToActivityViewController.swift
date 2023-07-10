//
//  AddProgramsToActivityViewController.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 17/06/2023.
//

import Foundation
import UIKit
import CoreData

class AddProgramsToActivityViewController: UIViewController {
    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var programsBodyView: UIView!
    @IBOutlet weak var programsTableView: UITableView!
    
    var activity: ActivityMO!
    var activityRepository: ActivityRepository!
    var programsFRC: NSFetchedResultsController<ProgramMO>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView()
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1/1).isActive = true
        imageView.image = ActivityType(rawValue: Int(activity.type))!.info.image?.withRenderingMode(.alwaysTemplate)
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
        
        postInit()
        setupFetchedResultsController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<ProgramMO> = ProgramMO.fetchRequest()
        let predicate = NSPredicate(format: "activity == %@", activity)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        programsFRC = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: activityRepository.dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        programsFRC.delegate = self
        do {
            try programsFRC.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    @objc func backButtonPressed() {
        
    }
    
    @IBAction func createProgramButtonPressed(_ sender: UIButton) {
        print("Create program button pressed")
        
        let createProgramsVC = storyboard?.instantiateViewController(withIdentifier: "CreateProgramsViewController") as! CreateProgramsViewController
        
        createProgramsVC.activity = activity
        createProgramsVC.activityRepository = activityRepository
        createProgramsVC.dismissCompletionHandler = {
            self.programsTableView.reloadData()
        }
        
        present(createProgramsVC, animated: true)
    }
}

extension AddProgramsToActivityViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Move these methods into an extension
    
    func postInit() {
        setupViewAppearance()
        setupTableView()
    }
    
    private func setupTableView() {
        programsTableView.delegate = self
        programsTableView.dataSource = self
        
        programsTableView.register(CustomTableViewHeaderFooter.self,
                                   forHeaderFooterViewReuseIdentifier: "ProgramsSection")
        
        registerTableViewCells()
    }
    
    private func registerTableViewCells() {
        let activityTableViewCell = UINib(nibName: ActivityTableViewCell.identifier,
                                  bundle: nil)
        self.programsTableView.register(activityTableViewCell,
                                forCellReuseIdentifier: "ProgramsCell")
    }
    
    private func setupViewAppearance() {
        //
        bodyView.layer.cornerRadius = 30
        bodyView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        programsBodyView.layer.cornerRadius = 20
        programsBodyView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    // MARK: Reminders Delegate & Datasource
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        tableView.sectionHeaderTopPadding = 0
        
        if (programsFRC.fetchedObjects?.isEmpty ?? false) {
            return nil
        }
        
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ProgramsSection") as! CustomTableViewHeaderFooter
        
        let text = "Programs"
        let titleRange = text.range(of: text)!
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)], range: NSRange(titleRange, in: text))
        view.title.attributedText = attributedString
        
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if programsFRC.fetchedObjects?.isEmpty ?? false {
            tableView.setEmptyView(title: "You haven't created any programs yet", message: "Create programs using the \"+\" button at the bottom")
        }
        else {
            tableView.restore()
        }
        return programsFRC.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProgramsCell") as! ActivityTableViewCell
        
        let program = programsFRC.object(at: indexPath)
        let activityType = ActivityType(rawValue: Int(program.activityType))!
        cell.programImageView.image = activityType.info.image
        cell.imageCircleView.backgroundColor = activityType.info.color
        cell.programTitleLabel.text = program.title
        cell.programSubtitleLabel.text = "\(program.reps) reps x \(program.sets) sets"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 150
    }
}

extension AddProgramsToActivityViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            programsTableView.insertRows(at: [newIndexPath!], with: .fade)
            break
        case .delete:
            programsTableView.deleteRows(at: [indexPath!], with: .fade)
            break
        case .update:
            programsTableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            programsTableView.moveRow(at: indexPath!, to: newIndexPath!)
        @unknown default:
            fatalError()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert: programsTableView.insertSections(indexSet, with: .fade)
        case .delete: programsTableView.deleteSections(indexSet, with: .fade)
        case .update, .move:
            fatalError("Invalid change type in controller(_:didChange:atSectionIndex:for:). Only .insert or .delete should be possible.")
        @unknown default:
            fatalError()
        }
    }

    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        programsTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        programsTableView.endUpdates()
    }
    
}

//
//#if DEBUG
//import SwiftUI
//
//@available(iOS 13, *)
//struct AddProgramsToActivityViewController_Preview: PreviewProvider {
//    static var previews: some View {
//        // view controller using programmatic UI
//        // Assuming your storyboard file name is "Main"
//        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "AddProgramsToActivityViewController").showPreview()
//    }
//}
//#endif
