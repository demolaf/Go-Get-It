//
//  NutritionViewController.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 07/07/2023.
//

import Foundation
import UIKit

class NutritionViewController: UIViewController {
    
    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var nutritionMainView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let text = "Explore"
        
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
        
        postInit()
    }
}

extension NutritionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: Move these methods into an extension
    
    func postInit() {
        setupCollectionView()
        setupViewAppearance()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let noOfCellsInRow = 2
        flowLayout.minimumInteritemSpacing = 12
        flowLayout.minimumLineSpacing = 24
        flowLayout.sectionInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        
        let totalWidthSpace = flowLayout.sectionInset.left
        + flowLayout.sectionInset.right - 24
        + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
        
        let totalHeightSpace = flowLayout.sectionInset.top + flowLayout.sectionInset.bottom - (flowLayout.minimumLineSpacing * CGFloat(noOfCellsInRow))
        
        let width = Int((collectionView.frame.size.width - totalWidthSpace) / CGFloat(noOfCellsInRow))
        let height = Int((collectionView.frame.size.height - totalHeightSpace) / CGFloat(noOfCellsInRow + 1))
        
        flowLayout.itemSize = CGSize(width: width, height: height)
        
//        flowLayout.itemSize = CGSize(width: (collectionView.frame.size.width/2)-6, height: (collectionView.frame.size.height/3)-8)
//        flowLayout.minimumInteritemSpacing = 12
//        flowLayout.minimumLineSpacing = 24
//        flowLayout.sectionInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        flowLayout.headerReferenceSize = CGSize(width: self.collectionView.frame.width, height: 55)
        
        registerCollectViewCell()
        registerHeaderView()
    }
    
    func registerCollectViewCell() {
        let nutritionCollectionViewCell = UINib(nibName: "NutritionCollectionViewCell",
                                                bundle: nil)
        collectionView.register(nutritionCollectionViewCell, forCellWithReuseIdentifier: "NutritionCell")
    }
    
    func registerHeaderView() {
        collectionView.register(UINib(nibName: CustomHeaderCollectionReusableView.identifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CustomHeaderCollectionReusableView.identifier)
    }
    
    private func setupViewAppearance() {
        //
        bodyView.layer.cornerRadius = 30
        bodyView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        nutritionMainView.layer.cornerRadius = 20
        nutritionMainView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NutritionCell", for: indexPath) as! CustomCollectionViewCell
        
        cell.imageView.image = Images.recipePlaceholderImage
        cell.titleLabel.text = "Hello World"
        cell.subtitleLabel.text = "Welcome to swift programming"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CustomHeaderCollectionReusableView.identifier, for: indexPath) as! CustomHeaderCollectionReusableView
            
            let text = "Healthy Foods"
            
            let titleRange = text.range(of: text)!
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)], range: NSRange(titleRange, in: text))
            
            headerView.titleLabel.attributedText = attributedString
            
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
    }
}
