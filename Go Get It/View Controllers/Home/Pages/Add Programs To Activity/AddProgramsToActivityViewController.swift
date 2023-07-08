//
//  AddProgramsToActivityViewController.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 17/06/2023.
//

import Foundation
import UIKit

class AddProgramsToActivityViewController: UIViewController {
    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var programsBodyView: UIView!
    @IBOutlet weak var programsTableView: UITableView!
    
    var activity: ActivityDataModel!
    var activityRepository: ActivityRepository!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView()
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1/1).isActive = true
        imageView.image = activity.activityType.info.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white
        
        let text = activity.activityTitle
        
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = true
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
        
        if !activity.programs.isEmpty {
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ProgramsSection") as! CustomTableViewHeaderFooter
            
            let text = "Programs"
            let titleRange = text.range(of: text)!
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)], range: NSRange(titleRange, in: text))
            view.title.attributedText = attributedString
            
            return view
        }
        
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if activity.programs.isEmpty {
            tableView.setEmptyView(title: "You haven't created any programs yet.", message: "Create programs using the \"+\" button at the bottom")
        }
        else {
            tableView.restore()
        }
        return activity.programs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProgramsCell") as! ActivityTableViewCell
        
        let program = activity.programs[indexPath.row]
        
        cell.programImageView.image = program.activityType.info.image
        cell.imageCircleView.backgroundColor = program.activityType.info.color
        cell.programTitleLabel.text = program.programTitle
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
