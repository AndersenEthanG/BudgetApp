//
//  ExpenseController.swift
//  Budgeter
//
//  Created by Ethan Andersen on 9/4/21.
//

import CoreData

class ExpenseController {
    
    // MARK: - Properties
    static let sharedInstance = ExpenseController()
    var expenses: [Expense] = []
    
    // Fetch Request
    private lazy var fetchRequest: NSFetchRequest<Expense> = {
        let request = NSFetchRequest<Expense>(entityName: "Expense")
        request.predicate = NSPredicate(value: true)
        return request
    }() // End of Fetch Request
    
    // MARK: - Functions
    func createExpense(newExpense: Expense) {
        expenses.append(newExpense)
        CoreDataStack.saveContext()
    } // End of Create expense
    
    func fetchExpenses(🐶: @escaping ( [Expense] ) -> Void) {
        do {
            expenses = try CoreDataStack.context.fetch(fetchRequest)
            🐶(expenses)
        } catch {
            print("Is line \(#line) working?")
        }
    } // End of Fetch expense
    
    func updateExpense() {
        CoreDataStack.saveContext()
    } // End of Update expense
    
    func deleteExpense(expenseToDelete: Expense) {
        if let index = expenses.firstIndex(of: expenseToDelete) {
            expenses.remove(at: index)
        }
        CoreDataStack.context.delete(expenseToDelete)
        CoreDataStack.saveContext()
    } // End of Delete expense
    
    
    func editPaymentSourceForAllExpenses(oldPaymentSourceName: String, newPaymentSourceName: String) {
        for expense in expenses {
            if expense.paymentSource == oldPaymentSourceName {
                expense.paymentSource = newPaymentSourceName
            } // End of If statement
        } // End of Loop
        updateExpense()
    } // End of Function
} // End of Class
