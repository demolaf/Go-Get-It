//
//  ExercisesListViewController.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 08/07/2023.
//

import UIKit

class ExercisesListViewController: UIViewController {

    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var exercisesMainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var exploreRepository: ExploreRepository!
    var bodyParts = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let text = "Exercises"
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension ExercisesListViewController: UITableViewDelegate, UITableViewDataSource {
    func setup() {
        setupTableView()
        setupViewAppearance()
        
        fetchBodyPartList()
    }
    
    func fetchBodyPartList() {
        exploreRepository.fetchBodyPartsList { response, error in
            self.bodyParts = response
            
            self.tableView.reloadData()
        }
    }
    
    private func setupViewAppearance() {
        //
        bodyView.layer.cornerRadius = 30
        bodyView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        exercisesMainView.layer.cornerRadius = 20
        exercisesMainView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        navigationController?.navigationBar.topItem?.backButtonDisplayMode = .minimal
        navigationController?.navigationBar.tintColor = .white
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
//        tableView.register(CustomTableViewHeaderFooter.self,
//                                   forHeaderFooterViewReuseIdentifier: "ExploreSection")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bodyParts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell")!
        
        var configuration = cell.defaultContentConfiguration()
        
        let bodyPart = bodyParts[indexPath.row]
        configuration.text = bodyPart.capitalized
        
        cell.contentConfiguration = configuration
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let exercisesForBodyPartVC = storyboard?.instantiateViewController(withIdentifier: "ExercisesForBodyPartViewController") as! ExercisesForBodyPartViewController
        
        exercisesForBodyPartVC.exploreRepository = exploreRepository
        exercisesForBodyPartVC.selectedBodyPart = bodyParts[indexPath.row]
        
        navigationController?.pushViewController(exercisesForBodyPartVC, animated: true)
    }
}
