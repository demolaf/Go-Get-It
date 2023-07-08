//
//  CircularProgressBar.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 03/07/2023.
//

import Foundation
import UIKit

@IBDesignable
class CircularProgressBar: UIView {
    
    // MARK: IBInspectables
    
    @IBInspectable var lineWidth: CGFloat = 50 {
        didSet{
            thumbLayer.lineWidth = lineWidth
            trackLayer.lineWidth = lineWidth - (0.20 * lineWidth)
        }
    }

    @IBInspectable private var labelText: String = "0" {
        didSet {
            label.text = labelText
        }
    }
    
    @IBInspectable private var labelSize: CGFloat = 20 {
        didSet {
            label.font = UIFont.systemFont(ofSize: labelSize)
        }
    }
    
    @IBInspectable private var percentage: CGFloat = 0.5 {
        didSet {
            setProgress(to: percentage, animate: false)
        }
    }
    
    // MARK: Public Properties
    
    var label = UILabel()
    
    var trackLayer = CAShapeLayer()
    
    var thumbLayer = CAShapeLayer()
    
    // MARK: Private Properties
    
    private var radius: CGFloat {
        get{
            if self.frame.width < self.frame.height { return (self.frame.width - lineWidth)/2 }
            else { return (self.frame.height - lineWidth)/2 }
        }
    }
    
    private var pathCenter: CGPoint {
        get {
            return self.convert(self.center, from:self.superview)
        }
    }
    
    // MARK: awakeFromNib
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    // MARK: Private Methods
    
    private func setupView() {
        setupBar()
        setupLabel(text: labelText)
        
    }
    
    private func setupBar(){
        self.layer.sublayers = nil
        drawTrackLayer()
        drawThumbLayer()
    }
    
    private func setupLabel(text: String) {
        label.text = text
        label.font = UIFont.systemFont(ofSize: labelSize)
        
        self.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant:0).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant:0).isActive = true
    }
    
    private func drawTrackLayer(){
        let path = UIBezierPath(arcCenter: pathCenter, radius: self.radius, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        self.trackLayer.path = path.cgPath
        self.trackLayer.strokeColor = UIColor.lightGray.cgColor
        self.trackLayer.lineWidth = lineWidth - (lineWidth * 20/100)
        self.trackLayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(trackLayer)
    }
    
    private func drawThumbLayer(){
        let endAngle = (-CGFloat.pi/2)
        let startAngle = 2 * CGFloat.pi + endAngle
        
        let path = UIBezierPath(arcCenter: pathCenter, radius: self.radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        
        thumbLayer.lineCap = CAShapeLayerLineCap.round
        thumbLayer.path = path.cgPath
        thumbLayer.lineWidth = lineWidth
        thumbLayer.fillColor = UIColor.clear.cgColor
        thumbLayer.strokeColor = UIColor.white.cgColor
        thumbLayer.strokeEnd = 0
        
        self.layer.addSublayer(thumbLayer)
    }
    
    
    func setProgress(to progressConstant: Double, animate: Bool) {
        var progress: Double {
            get {
                if progressConstant > 1 { return 1 }
                else if progressConstant < 0 { return 0 }
                else { return progressConstant }
            }
        }
        
        thumbLayer.strokeEnd = CGFloat(progress)
        
        if animate {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = 0
            animation.toValue = progress
            animation.duration = 2
            animation.fillMode = .forwards
            animation.isRemovedOnCompletion = false
            thumbLayer.add(animation, forKey: "thumbAnimation")
        } else {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.byValue = progress
            animation.duration = 0
            animation.fillMode = .forwards
            animation.isRemovedOnCompletion = false
            thumbLayer.add(animation, forKey: "thumbAnimation")
        }
    }
}

extension UIView {

    func applyGradient(isVertical: Bool, colorArray: [UIColor]) {
        layer.sublayers?.filter({ $0 is CAGradientLayer }).forEach({ $0.removeFromSuperlayer() })
         
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colorArray.map({ $0.cgColor })
        if isVertical {
            //top to bottom
            gradientLayer.locations = [0.0, 1.0]
        } else {
            //left to right
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        }
        
        backgroundColor = .clear
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }

}
