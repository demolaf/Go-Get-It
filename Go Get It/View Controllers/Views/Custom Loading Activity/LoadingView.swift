//
//  LoadingView.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 10/07/2023.
//

import UIKit

class LoadingView: UIView {
    @IBOutlet weak var loadingMessage: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func isLoading(_ loading: Bool) {
        if loading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}
