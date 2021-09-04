//
//  PurchaseController.swift
//  Budgeter
//
//  Created by Ethan Andersen on 9/4/21.
//

import CoreData

class PurchaseController {
    
    // MARK: - Properties
    static let sharedInstance = PurchaseController()
    var purchases: [Purchase] = []
    
    // Fetch Request
    private lazy var fetchRequest: NSFetchRequest<Purchase> = {
        let request = NSFetchRequest<Purchase>(entityName: "Purchase")
        request.predicate = NSPredicate(value: true)
        return request
    }() // End of Fetch Request
    
    // MARK: - Functions
    func createPurchase(newPurchase: Purchase) {
        purchases.append(newPurchase)
        CoreDataStack.saveContext()
    } // End of Create purchase
    
    func fetchPurchases() {
        purchases = (try? CoreDataStack.context.fetch(fetchRequest)) ?? []
    } // End of Fetch purchase
    
    func updatePurchase() {
        CoreDataStack.saveContext()
    } // End of Update purchase
    
    func deletePurchase(purchaseToDelete: Purchase) {
        if let index = purchases.firstIndex(of: purchaseToDelete) {
            purchases.remove(at: index)
        }
        CoreDataStack.context.delete(purchaseToDelete)
        CoreDataStack.saveContext()
    } // End of Delete purchase
    
} // End of Class
