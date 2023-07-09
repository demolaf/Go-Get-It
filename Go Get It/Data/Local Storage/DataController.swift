//
//  DataController.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 09/07/2023.
//

import Foundation
import CoreData

// NOTE: Read about the difference between Class and Struct in swift
// the issue here is we don't want to use struct to define our object
// because we don't want multiple instances/copies of the object

// So are they saying Structs can't be a singleton? or what read more!

// This class will do three things
// 1. Hold/Create a PERSISTENT CONTAINER INSTANCE
// 2. Load the PERSISTENT STORE
// 3. Help us access the CONTEXT

class DataController {
    // 1.
    let persistentContainer: NSPersistentContainer
    
    // 3.
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var backgroundContext: NSManagedObjectContext!
    
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func configureContexts() {
        backgroundContext = persistentContainer.newBackgroundContext()
        
        viewContext.automaticallyMergesChangesFromParent = true
        backgroundContext.automaticallyMergesChangesFromParent = true
        
        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }
    
    // 2.
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else { fatalError(error!.localizedDescription) }
            
            self.autosaveViewContext()
            self.configureContexts()
            completion?()
        }
    }
}

extension DataController {
    func autosaveViewContext(interval: TimeInterval = 30) {
        print("autosaving")
        guard interval > 0 else {
            print("cannot set negative autosave interval")
            return
        }
        
        if viewContext.hasChanges {
            try? viewContext.save()
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + interval) {
            self.autosaveViewContext(interval: interval)
        }
    }
}
