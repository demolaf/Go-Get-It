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
    
    private let apiClient: APIClient
    private let dataController: DataController
    private let exploreAPI: ExploreAPI
    private let activityAPI: ActivityAPI
    
    init() {
        //
        self.apiClient = APIClientImpl()
        self.dataController = DataController(modelName: "GoGetIt")
        self.dataController.load()
        
        //
        self.exploreAPI = ExploreAPI(apiClient: apiClient)
        self.activityAPI = ActivityAPI(dataController: dataController)
        
        //
        self.authRepository = AuthenticationRepositoryImpl()
        self.activityRepository = ActivityRepositoryImpl(activityAPI: activityAPI)
        self.remindersRepository = RemindersRepositoryImpl()
        self.exploreRepository = ExploreRepositoryImpl(exploreAPI: exploreAPI)
    }
}
