//
//  CustomTableViewHeader.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 06/07/2023.
//

import Foundation
import UIKit

class CustomTableViewHeaderFooter: UITableViewHeaderFooterView {
    let title = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureContents()
    }
    
    
    func configureContents() {
        title.translatesAutoresizingMaskIntoConstraints = false
        
        //Stack View
        let stackView   = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis  = .horizontal
        stackView.distribution  = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 12.0
        
        stackView.addArrangedSubview(title)
        
        contentView.addSubview(stackView)
        contentView.backgroundColor = .white
    }
}
