//
//  SavingController.swift
//  Budgeter
//
//  Created by Ethan Andersen on 9/4/21.
//

import CoreData

class SavingController {
    
    // MARK: - Properties
    static let sharedInstance = SavingController()
    var savings: [Saving] = []
    
    // Fetch Request
    private lazy var fetchRequest: NSFetchRequest<Saving> = {
        let request = NSFetchRequest<Saving>(entityName: "Saving")
        request.predicate = NSPredicate(value: true)
        return request
    }() // End of Fetch Request
    
    // MARK: - Functions
    func createSaving(newSaving: Saving) {
        savings.append(newSaving)
        CoreDataStack.saveContext()
    } // End of Create saving
    
    func fetchSavings(🐶: @escaping ( [Saving] ) -> Void) {
        do {
            savings = try CoreDataStack.context.fetch(fetchRequest)
            🐶(savings)
        } catch {
            print("Is line \(#line) working?")
        }
    } // End of Fetch saving
    
    func updateSaving() {
        CoreDataStack.saveContext()
    } // End of Update saving
    
    func deleteSaving(savingToDelete: Saving) {
        if let index = savings.firstIndex(of: savingToDelete) {
            savings.remove(at: index)
        }
        CoreDataStack.context.delete(savingToDelete)
        CoreDataStack.saveContext()
    } // End of Delete saving
    
} // End of Class
