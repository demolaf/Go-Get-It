//
//  RepositoryProvider.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 05/07/2023.
//

import Foundation

struct RepositoryProvider  {
    let authRepository: AuthenticationRepository
    let activityRepository: ActivityRepository
    let remindersRepository: RemindersRepository
    let exploreRepository: ExploreRepository
    
    let apiClient: APIClient
    
    init() {
        self.apiClient = APIClientImpl()
        
        self.authRepository = AuthenticationRepositoryImpl()
        self.activityRepository = ActivityRepositoryImpl()
        self.remindersRepository = RemindersRepositoryImpl()
        self.exploreRepository = ExploreRepositoryImpl(exploreAPI: ExploreAPI(apiClient: apiClient))
    }
}
