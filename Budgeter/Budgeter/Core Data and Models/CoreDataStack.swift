//
//  CoreDataStack.swift
//  Budgeter
//
//  Created by Ethan Andersen on 9/4/21.
//

import CoreData
import CloudKit

enum CoreDataStack {
    static let container: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "Budgeter")
        
        guard let description = container.persistentStoreDescriptions.first else { fatalError("No description found!") }
        description.setOption(true as NSObject, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Error loading persistent stores \(error.localizedDescription)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        return container
    }() // End of Container
    
    static var context: NSManagedObjectContext { container.viewContext }
    
    // Saving things
    static func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context \(error)")
            }
        }
    }
} // End of Enum
