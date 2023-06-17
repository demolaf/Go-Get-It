//
//  RemindersTableViewCell.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 15/06/2023.
//

import UIKit

class RemindersTableViewCell: UITableViewCell {

    @IBOutlet weak var reminderLabel: UILabel!
    @IBOutlet weak var checkbox: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func checkboxTapped(_ sender: Any) {
        
    }
}
