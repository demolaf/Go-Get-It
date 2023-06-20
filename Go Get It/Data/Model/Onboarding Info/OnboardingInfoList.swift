//
//  OnboardingInfoList.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 13/06/2023.
//

import Foundation

class OnboardingInfoList {
    static let data: [OnboardingData] = [
        OnboardingData(header: "Create Routine", subitle: "Create your workout routine for the program you have set for the day.", buttonCTA: "Create Routine", image: Images.onboardingScreen1!, backgroundColor: Colors.onboardingScreen1!, currentPage: 0),
        OnboardingData(header: "Meal Plans", subitle: "Find meal plans that match your fitness journey.", buttonCTA: "Create Meal Plan", image: Images.onboardingScreen2!, backgroundColor: Colors.onboardingScreen2!, currentPage: 1),
        OnboardingData(header: "Workout History", subitle: "See records of your last workout and get recommendations.", buttonCTA: "See How It Works", image: Images.onboardingScreen3!, backgroundColor: Colors.onboardingScreen3!, currentPage: 2),
    ]
}
