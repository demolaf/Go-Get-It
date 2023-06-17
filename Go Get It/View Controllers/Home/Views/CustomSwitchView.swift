//
//  CustomUISwitch.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 17/06/2023.
//

import UIKit

@IBDesignable class CustomSwitchView: UISwitch {

    @IBInspectable var scale : CGFloat = 1{
        didSet{
            setup()
        }
    }

    //from storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    //from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup(){
        self.transform = CGAffineTransform(scaleX: scale, y: scale)
    }

    override func prepareForInterfaceBuilder() {
        setup()
        super.prepareForInterfaceBuilder()
    }
}
