//
//  CreateActivityViewController.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 16/06/2023.
//

import Foundation
import UIKit

// Would it be possible to parse the activityType to a
// Struct, basically instead of a String rawValue we
// would have a struct type
enum ActivityType: String {
    case upper = "Upper Body"
    case arm = "Arms"
    case legs = "Legs"
    case cardio = "Cardio"
    case yoga = "Yoga"
}

class CreateActivityViewController: UIViewController {
    
    @IBOutlet weak var formView: UIView!
    @IBOutlet weak var activityImageView: CircleView!
    @IBOutlet weak var activityLabelView: UILabel!
    
    var activityType: ActivityType!
    var parentNavigationController: UINavigationController!
    
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
        
        //
        activityLabelView.text = "Upper"
    }
    
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        print("Continue button pressed")
        dismiss(animated: true) {
            print("Dismiss called")
            let addProgramsToActivityVC = self.storyboard?.instantiateViewController(withIdentifier: "AddProgramsToActivityViewController") as! AddProgramsToActivityViewController
        
            self.parentNavigationController.pushViewController(addProgramsToActivityVC, animated: true)
            print("Dismiss called finished")
        }
    }
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct CreateActivityViewController_Preview: PreviewProvider {
    static var previews: some View {
        // view controller using programmatic UI
        // Assuming your storyboard file name is "Main"
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "CreateActivityViewController").showPreview()
    }
}
#endif
