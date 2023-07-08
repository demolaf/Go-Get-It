//
//  CustomTableViewCell.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 05/07/2023.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {
    static let identifier = "ActivityTableViewCell"
    
    @IBOutlet weak var programImageView: UIImageView!
    @IBOutlet weak var programTitleLabel: UILabel!
    @IBOutlet weak var programSubtitleLabel: UILabel!
    @IBOutlet weak var imageCircleView: CircleView!
    @IBOutlet weak var completedTitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        completedTitleLabel.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func markAsCompleted(completed: Bool) {
        completedTitleLabel.isHidden = !completed
    }
}
