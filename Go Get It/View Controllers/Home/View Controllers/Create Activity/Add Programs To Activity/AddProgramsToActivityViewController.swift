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
    @IBOutlet weak var programsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

        self.navigationItem.titleView = stackView
        
        navigationController?.isNavigationBarHidden = false
        navigationItem.titleView = stackView
    
        self.navigationController?.navigationBar.backItem?.title = ""
        self.navigationController?.navigationBar.tintColor = .white
        
        postInit()
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

        present(createProgramsVC, animated: true)
    }
}

extension AddProgramsToActivityViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Move these methods into an extension
    
    func postInit() {
        programsTableView.delegate = self
        programsTableView.dataSource = self
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProgramsCell")!
        
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
struct AddProgramsToActivityViewController_Preview: PreviewProvider {
    static var previews: some View {
        // view controller using programmatic UI
        // Assuming your storyboard file name is "Main"
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "AddProgramsToActivityViewController").showPreview()
    }
}
#endif
