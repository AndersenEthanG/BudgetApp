//
//  BudgetController.swift
//  Budgeter
//
//  Created by Ethan Andersen on 9/13/21.
//

import Foundation

class BudgetController {
    
    // MARK: - Properties
    var budget: Budget?
    
    static let sharedInstance = BudgetController()
    
    var incomeTotal: Double = 0
    var savingTotal: Double = 0
    var reoccuringTotal: Double = 0
    var remainderAmount: Double = 0
    
    
    // MARK: - Functions
    func fetchBudget(totalPurchases: Double, 🐶: @escaping ( Budget ) -> Void) {
        // Fetch all budget elements from the CoreData
        // All of the values should be in monthly amounts
        
        fetchAndCalculateIncome()
        fetchAndCalculateSaving()
        fetchAndCalculateReoccuring()
        
        let incomeTotal = self.incomeTotal
        let savingTotal = self.savingTotal
        let reoccuringTotal = self.reoccuringTotal
        
        let fetchedBudget = Budget(incomeTotal: incomeTotal, savingTotal: savingTotal, reoccuringTotal: reoccuringTotal)
        🐶(fetchedBudget)
    } // End of fetch budget
    
    
    // Income
    func fetchAndCalculateIncome() {
        var incomeTotal: Double = 0
        /// This will calculate based on all of the income tab money and return a single monthly value
        let frequency: FilterBy = .month
        incomeTotal = IncomeController.sharedInstance.getTotalIncome(frequency: frequency)
        
        self.incomeTotal = incomeTotal
    } // End of Fetch and calculate income
    
    
    // Saving
    func fetchAndCalculateSaving() {
        // This will calculate how much money based on percent of income and natural savings per month, how much money we save
        var totalMonthAmountSaved: Double = 0
        
        SavingController.sharedInstance.fetchSavings { fetchedSavings in
            for saving in fetchedSavings {
                let saving: Saving = saving
                let rate = saving.amount
                let currentRate: FilterBy = (saving.frequency?.formatToFilterBy())!
                let desiredRate: FilterBy = .month
                
                let monthlySaving = convertRate(rate: rate, currentRate: currentRate, desiredRate: desiredRate)
                
                switch saving.isPercent {
                case true:
                    let incomeTotal = self.incomeTotal
                    let monthlySavingPercent = ( rate / 100 )
                    
                    // This will return how many $$$ we save each month based on our income
                    let monthlySavingValue = ( incomeTotal * monthlySavingPercent )
                    totalMonthAmountSaved += monthlySavingValue
                case false:
                    let monthlySavedAmount = monthlySaving
                    totalMonthAmountSaved += monthlySavedAmount
                } // End of Switch
                
            } // End of For loop
            
            self.savingTotal = totalMonthAmountSaved
        } // End of Fetch savings
    } // End of Function
    
    
    // Reoccuring
    func fetchAndCalculateReoccuring() {
        var totalExpenses: Double = 0
        
        ExpenseController.sharedInstance.fetchExpenses { fetchedExpenses in
            for expense in fetchedExpenses {
                let expense: Expense = expense
                let rate = expense.amount
                let currentRate: FilterBy = (expense.frequency?.formatToFilterBy())!
                let desiredRate: FilterBy = .month
                
                let monthlyExpense = convertRate(rate: rate, currentRate: currentRate, desiredRate: desiredRate)
                
                totalExpenses += monthlyExpense
            } // End of Loop
            
            self.reoccuringTotal = totalExpenses
        } // End of fetch function
    } // End of Function
    
} // End of Class
