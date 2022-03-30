//
//  DebtController.swift
//  Budgeter
//
//  Created by Ethan Andersen on 9/4/21.
//

import CoreData

class DebtController {
    
    // MARK: - Properties
    static let sharedInstance = DebtController()
    var debts: [Debt] = []
    
    // Fetch Request
    private lazy var fetchRequest: NSFetchRequest<Debt> = {
        let request = NSFetchRequest<Debt>(entityName: "Debt")
        request.predicate = NSPredicate(value: true)
        return request
    }() // End of Fetch Request
    
    // MARK: - Functions
    func createDebt(newDebt: Debt) {
        debts.append(newDebt)
        CoreDataStack.saveContext()
    } // End of Create debt
    
    func fetchDebts(🐶: @escaping ( [Debt] ) -> Void) {
        do {
            debts = try CoreDataStack.context.fetch(fetchRequest)
            🐶(debts)
        }
        catch {
            print("Is line \(#line) working?")
        }
    } // End of Fetch debt
    
    func updateDebt() {
        CoreDataStack.saveContext()
    } // End of Update debt
    
    func deleteDebt(debtToDeleteUUID: String) {
        if let debtToDelete = debts.first(where: { $0.uuid == debtToDeleteUUID }) {
            
            if let index = debts.firstIndex(of: debtToDelete) {
                debts.remove(at: index)
            }
            
            CoreDataStack.context.delete(debtToDelete)
            CoreDataStack.saveContext()
        }
    } // End of Delete debt
    
} // End of Class
