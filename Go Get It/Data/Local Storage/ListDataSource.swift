//
//  ListDataSource.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 09/07/2023.
//

import Foundation
import UIKit
import CoreData

class ListDataSource<EntityType: NSManagedObject, CellType: UITableViewCell>: NSObject, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    var tableView: UITableView!
    var configure: (CellType, EntityType) -> Void
    var fetchedResultsController: NSFetchedResultsController<EntityType>!
    
    init(tableView: UITableView, managedObjectContext: NSManagedObjectContext, fetchRequest: NSFetchRequest<EntityType>, configure: @escaping (CellType, EntityType) -> Void) {
        self.tableView = tableView
        self.configure = configure
        super.init()
        
        self.tableView.dataSource = self
        setupFetchedResultsController(managedObjectContext: managedObjectContext, fetchRequest: fetchRequest)
    }
    
    private func setupFetchedResultsController(managedObjectContext: NSManagedObjectContext, fetchRequest: NSFetchRequest<EntityType>) {
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: "")
        
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }

    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        default:
            break
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[0].numberOfObjects ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entity = fetchedResultsController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CellType.self), for: indexPath) as! CellType
        
        // Configure cell
        configure(cell, entity)
        
        return cell
    }
}

