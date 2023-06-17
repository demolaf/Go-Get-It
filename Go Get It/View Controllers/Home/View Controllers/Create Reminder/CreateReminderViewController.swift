//
//  CreateReminderViewController.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 17/06/2023.
//

import Foundation
import UIKit

class CreateReminderViewController: UIViewController {
    
    @IBOutlet weak var formView: UIView!
    @IBOutlet weak var reminderSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        if let sheet = sheetPresentationController {
                sheet.detents = [
                    .custom { context in
                        return self.formView.frame.height
                    }
                ]
            sheet.preferredCornerRadius = 30
            }
    }
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct CreateReminderViewController_Preview: PreviewProvider {
    static var previews: some View {
        // view controller using programmatic UI
        // Assuming your storyboard file name is "Main"
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "CreateReminderViewController").showPreview()
    }
}
#endif

