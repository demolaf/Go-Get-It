//
//  CustomHeaderCollectionReusableView.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 07/07/2023.
//

import UIKit

class CustomHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "CustomHeaderCollectionReusableView"
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
