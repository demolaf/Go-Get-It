//
//  EmptyView+TableView.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 06/07/2023.
//

import Foundation
import UIKit

extension UITableView {
    func setEmptyView(title: String, message: String) {
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        messageLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        messageLabel.textColor = .lightGray
        messageLabel.font = .systemFont(ofSize: 17)
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        
        let stackView = UIStackView()
        
        stackView.axis  = .vertical
        stackView.distribution  = .fill
        stackView.alignment = .fill
        stackView.spacing = 12.0
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(messageLabel)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        emptyView.addSubview(stackView)
        
        stackView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
        stackView.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
        
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
