//
//  ExploreTableViewCell.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 08/07/2023.
//

import UIKit

class ExploreTableViewCell: UITableViewCell {
    static let identifier = "ExploreTableViewCell"
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //
        self.clipsToBounds = false
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = 0.75
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowRadius = 3.0
        view.layer.isGeometryFlipped = false
        
        //
        itemImageView.layer.cornerRadius = 20
        itemImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        
        //
        let titleText = titleLabel.text ?? ""
        let titleRange = titleText.range(of: titleText)!
        let titleAttributedString = NSMutableAttributedString(string: titleText)
        titleAttributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .bold)], range: NSRange(titleRange, in: titleText))
        titleLabel.attributedText = titleAttributedString
        titleLabel.numberOfLines = 0
        
        //
        let subtitleText = subtitleLabel.text ?? ""
        let subtitleRange = subtitleText.range(of: subtitleText)!
        let subtitleAttributedString = NSMutableAttributedString(string: subtitleText)
        subtitleAttributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular)], range: NSRange(subtitleRange, in: subtitleText))
        subtitleLabel.attributedText = subtitleAttributedString
        subtitleLabel.numberOfLines = 0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
