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
    
//    lazy var appBarTitleView: TitleView = {
//        let titleView = TitleView()
//
//        titleView.imageView.isHidden = true
//
//        let text = "Workouts"
//
//        titleView.view.backgroundColor = .clear
//
//        let titleRange = text.range(of: text)!
//
//        let attributedString = NSMutableAttributedString(string: text)
//
//        attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .medium)], range: NSRange(titleRange, in: text))
//
//        titleView.label.attributedText = attributedString
//
//        return titleView
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationItem.titleView = appBarTitleView
        
        postInit()
    }
}

extension WorkoutStatsViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Move these methods into an extension
    
    func postInit() {
        setupViewAppearance()
    }
    
    private func setupViewAppearance() {
        //
        bodyView.layer.cornerRadius = 30
        bodyView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    // MARK: Reminders Delegate & Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RemindersCell") as! RemindersTableViewCell
        
        cell.reminderLabel.text = "Drink 200ml of water."
        
        cell.backgroundColor = .clear
        
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
