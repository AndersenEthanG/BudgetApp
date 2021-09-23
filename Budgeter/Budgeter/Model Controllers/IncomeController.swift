//
//  IncomeController.swift
//  Budgeter
//
//  Created by Ethan Andersen on 9/4/21.
//

import CoreData

class IncomeController {
    
    // MARK: - Properties
    static let sharedInstance = IncomeController()
    var incomes: [Income] = []
    
    // Fetch Request
    private lazy var fetchRequest: NSFetchRequest<Income> = {
        let request = NSFetchRequest<Income>(entityName: "Income")
        request.predicate = NSPredicate(value: true)
        return request
    }() // End of Fetch Request
    
    // MARK: - Functions
    func createIncome(newIncome: Income) {
        incomes.append(newIncome)
        CoreDataStack.saveContext()
    } // End of Create income
    
    func fetchIncomes(🐶: @escaping ( [Income] ) -> Void) {
        incomes = (try? CoreDataStack.context.fetch(fetchRequest)) ?? []
        🐶(incomes)
    } // End of Fetch income
    
    func updateIncome() {
        CoreDataStack.saveContext()
    } // End of Update income
    
    func deleteIncome(incomeToDelete: Income) {
        if let index = incomes.firstIndex(of: incomeToDelete) {
            incomes.remove(at: index)
        }
        CoreDataStack.context.delete(incomeToDelete)
        CoreDataStack.saveContext()
    } // End of Delete income
    
    func getTotalIncome(frequency: FilterBy) -> Double {
        var finalResult: Double = 0
        
        fetchIncomes { fetchedIncomes in
            for income in fetchedIncomes {
                let amount = income.amount
                let currentRate: FilterBy = (income.frequency?.formatToFilterBy())!
                let desiredRate: FilterBy = frequency
                
                let amountPerMonth = convertRate(rate: amount, currentRate: currentRate, desiredRate: desiredRate)
                
                finalResult += amountPerMonth
            } // End of Loop
        } // End of fetch
        return finalResult
    } // End of Get total income
    
} // End of Class
