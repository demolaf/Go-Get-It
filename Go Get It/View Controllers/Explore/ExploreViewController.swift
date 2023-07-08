//
//  ExploreViewController.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 16/06/2023.
//

import Foundation
import UIKit

class ExploreViewController: UIViewController {
    
    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var exploreMainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var exploreRepository: ExploreRepository!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exploreRepository = (UIApplication.shared.delegate as! AppDelegate).repositoryProvider.exploreRepository
        
        let text = "Explore"
        
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

extension ExploreViewController: UITableViewDelegate, UITableViewDataSource {

    func setup() {
        setupTableView()
        setupViewAppearance()
    }
    
    private func setupViewAppearance() {
        //
        bodyView.layer.cornerRadius = 30
        bodyView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        exploreMainView.layer.cornerRadius = 20
        exploreMainView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(CustomTableViewHeaderFooter.self,
                                   forHeaderFooterViewReuseIdentifier: "ExploreSection")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let exercisesListVC = storyboard?.instantiateViewController(withIdentifier: "ExercisesListViewController") as! ExercisesListViewController
            
            exercisesListVC.exploreRepository = exploreRepository
            
            navigationController?.pushViewController(exercisesListVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExploreTableViewCell.identifier) as! ExploreTableViewCell
        
        let exploreItem = exploreRepository.exploreTableListItem[indexPath.row]
        
        cell.itemImageView.image = exploreItem.image
        cell.titleLabel.text = exploreItem.title
        cell.subtitleLabel.text = exploreItem.description
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exploreRepository.exploreTableListItem.count
    }
}
