//
//  CircleView.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 15/06/2023.
//

import UIKit

@IBDesignable
class CircleView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = 0.5 * bounds.size.width
        layer.masksToBounds = true
    }
}
