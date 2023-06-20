//
//  OnboardingPageViewController.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 13/06/2023.
//

import UIKit

class OnboardingPageViewController: UIPageViewController {
    
    lazy var onboardingViewControllers: [UIViewController] = {
        var viewControllers: [OnboardingViewController] = []
        OnboardingInfoList.data.forEach { onboardingInfo in
            let vc = storyboard?.instantiateViewController(withIdentifier: "OnboardingViewController") as! OnboardingViewController
            vc.onboardingData = onboardingInfo
            vc.pageViewController = self
            viewControllers.append(vc)
        }
        
        return viewControllers
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        delegate = self
        dataSource = self
        
        self.setViewControllers([onboardingViewControllers.first!], direction: .forward, animated: true)
    }
    
    func goToNextPage(currentPage: Int) {
        print("Go to next page called")
        
        let vcs = onboardingViewControllers
        //or self.viewControllers
        let currentPage = currentPage
        let nextPage = currentPage + 1

        if nextPage < vcs.count {
            let nextVC = vcs[nextPage]
            self.setViewControllers([nextVC], direction: .forward, animated: true)
        }
    }
}

extension OnboardingPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = onboardingViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard onboardingViewControllers.count > previousIndex else {
            return nil
        }
        
        return onboardingViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = onboardingViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let onboardingViewControllersCount = onboardingViewControllers.count
        
        guard onboardingViewControllersCount != nextIndex else {
            return nil
        }
        
        guard onboardingViewControllersCount > nextIndex else {
            return nil
        }
        
        return onboardingViewControllers[nextIndex]
    }
}
