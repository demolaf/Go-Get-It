//
//  NutritionCollectionViewCell.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 06/07/2023.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.clipsToBounds = false
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = 0.75
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowRadius = 3.0
        view.layer.isGeometryFlipped = false
        
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 2
        subtitleLabel.lineBreakMode = .byWordWrapping
        subtitleLabel.numberOfLines = 2
        
        imageView.layer.cornerRadius = 10
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        
//            imageView.image = nil
//        
//    }

    func isImageLoading(_ loading: Bool) {
        if loading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
            
        }
    }
}
