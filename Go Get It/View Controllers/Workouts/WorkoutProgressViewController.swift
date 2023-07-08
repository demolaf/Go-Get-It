//
//  WorkoutProgressViewController.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 29/06/2023.
//

import UIKit

class WorkoutProgressViewController: UIViewController {
    
    @IBOutlet weak var progressMessageTextLabel: UILabel!
    @IBOutlet weak var progressBar: CircularProgressBar!
    @IBOutlet weak var workoutsBodyView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var activity: ActivityDataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        imageView.image = Images.upperBodyIcon?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white
        
        let text = "Chest Day"
        
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
        if activity.programs.isEmpty {
            tableView.setEmptyView(title: "No programs yet.", message: "")
        }
        else {
            tableView.restore()
        }
        return activity.programs.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        tableView.sectionHeaderTopPadding = 0
        
        if !activity.programs.isEmpty {
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
        
        let program = activity.programs[indexPath.row]
        
        cell.imageCircleView.backgroundColor = program.activityType.info.color
        cell.programImageView.image = program.activityType.info.image
        cell.programTitleLabel.text = program.programTitle
        cell.programSubtitleLabel.text = "\(program.reps) reps x \(program.sets) sets"
        cell.markAsCompleted(completed: program.completed)
        
        return cell
    }
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct WorkoutProgressViewController_Preview: PreviewProvider {
    static var previews: some View {
        // view controller using programmatic UI
        // Assuming your storyboard file name is "Main"
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "WorkoutProgressViewController").showPreview()
    }
}
#endif
