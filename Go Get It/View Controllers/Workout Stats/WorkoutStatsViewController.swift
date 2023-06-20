//
//  WorkoutStatsViewController.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 16/06/2023.
//

import Foundation
import UIKit

class WorkoutStatsViewController: UIViewController {

    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var workoutsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let text = "Workout"
        
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
        
        stackView.addArrangedSubview(textLabel)
        
        navigationItem.titleView = stackView
        
//        navigationController?.navigationBar.standardAppearance.shadowColor = .clear
//        navigationController?.navigationBar.scrollEdgeAppearance?.shadowColor = .clear
//
        postInit()
    }
}

extension WorkoutStatsViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Move these methods into an extension
    
    func postInit() {
        workoutsTableView.delegate = self
        workoutsTableView.dataSource = self
        
        workoutsTableView.register(MyCustomHeader.self,
                                   forHeaderFooterViewReuseIdentifier: "IncompleteSection")
        workoutsTableView.register(MyCustomHeader.self,
                                   forHeaderFooterViewReuseIdentifier: "CompleteSection")
        
        setupViewAppearance()
    }
    
    private func setupViewAppearance() {
        //
        bodyView.layer.cornerRadius = 30
        bodyView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    // MARK: Reminders Delegate & Datasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "IncompleteSection") as! MyCustomHeader
            
            let text = "Incomplete Workouts"
            let titleRange = text.range(of: text)!
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)], range: NSRange(titleRange, in: text))
            view.title.attributedText = attributedString
            
            return view
        } else {
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CompleteSection") as! MyCustomHeader
            
            let text = "Complete Workouts"
            let titleRange = text.range(of: text)!
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)], range: NSRange(titleRange, in: text))
            view.title.attributedText = attributedString
            
            return view
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutsCell")!
        
        var configuration = cell.defaultContentConfiguration()
        
        configuration.image = Images.upperBodyIcon
        configuration.text = "Hello"
        configuration.secondaryText = "World"

        
        cell.contentConfiguration = configuration
        
        return cell
    }
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct WorkoutStatsViewController_Preview: PreviewProvider {
    static var previews: some View {
        // view controller using programmatic UI
        // Assuming your storyboard file name is "Main"
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "WorkoutStatsViewController").showPreview()
    }
}
#endif
