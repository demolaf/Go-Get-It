//
//  UIViewControllerExtension.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 13/06/2023.
//

import Foundation
import UIKit
import SwiftUI

extension UIViewController {
    // enable preview for UIKit
    // source: https://fluffy.es/xcode-previews-uikit/
    @available(iOS 13, *)
    private struct Preview: UIViewControllerRepresentable {
        // this variable is used for injecting the current view controller
        let viewController: UIViewController
        
        func makeUIViewController(context: Context) -> UIViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
            //
        }
    }
    
    @available(iOS 13, *)
    func showPreview() -> some View {
        Preview(viewController: self)
    }
}
