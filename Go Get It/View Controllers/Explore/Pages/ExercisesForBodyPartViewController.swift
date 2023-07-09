//
//  ExercisesForBodyPartViewController.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 08/07/2023.
//

import UIKit

class ExercisesForBodyPartViewController: UIViewController {

    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var exercisesMainView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var exploreRepository: ExploreRepository!
    var selectedBodyPart: String!
    var exercsisesForBodyPart = [ExerciseForBodyPart]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let text = selectedBodyPart.capitalized
        
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
        
        navigationController?.navigationBar.topItem?.backButtonDisplayMode = .minimal
        navigationController?.navigationBar.tintColor = .white
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchExercisesForBodyPart()
    }
}

extension ExercisesForBodyPartViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: Move these methods into an extension
    
    func setup() {
        setupCollectionView()
        setupViewAppearance()
    }
    
    func fetchExercisesForBodyPart() {
        exploreRepository.fetchExercisesForBodyPart(bodyPart: selectedBodyPart) { exercisesForBodyPart, error in
            self.exercsisesForBodyPart = exercisesForBodyPart
            
            self.collectionView.reloadData()
        }
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
        
        registerCollectViewCell()
        registerHeaderView()
    }
    
    func registerCollectViewCell() {
        let customCollectionViewCell = UINib(nibName: "CustomCollectionViewCell",
                                                bundle: nil)
        collectionView.register(customCollectionViewCell, forCellWithReuseIdentifier: "ExerciseCell")
    }
    
    func registerHeaderView() {
        collectionView.register(UINib(nibName: CustomHeaderCollectionReusableView.identifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CustomHeaderCollectionReusableView.identifier)
    }
    
    private func setupViewAppearance() {
        //
        bodyView.layer.cornerRadius = 30
        bodyView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        exercisesMainView.layer.cornerRadius = 20
        exercisesMainView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return exercsisesForBodyPart.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExerciseCell", for: indexPath) as! CustomCollectionViewCell
        
        let exerciseForBodyPart = exercsisesForBodyPart[indexPath.row]
        
        if let url = URL(string: exerciseForBodyPart.gifURL) {
            cell.isImageLoading(true)
            exploreRepository.fetchExerciseImage(url: url) { data in
                if let data = data {
                    cell.imageView.image = UIImage.gif(data: data)
                    cell.isImageLoading(false)
                }
            }
        }

        cell.titleLabel.text = exerciseForBodyPart.name.capitalized
        cell.subtitleLabel.text = exerciseForBodyPart.target.capitalized
        
        return cell
    }
}
