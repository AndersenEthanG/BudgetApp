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
    func fetchBudget(🐶: @escaping ( Budget ) -> Void) {
        // Fetch all budget elements from the CoreData
        // All of the values should be in monthly amounts
        fetchAndCalculateIncome()
        fetchAndCalculateSaving()
        fetchAndCalculateReoccuring()
        calculateRemainder()
        
        let incomeTotal = self.incomeTotal
        let savingTotal = self.savingTotal
        let remainderAmount = self.remainderAmount
        let reoccuringTotal = self.reoccuringTotal
                
        let fetchedBudget = Budget(incomeTotal: incomeTotal, savingTotal: savingTotal, reoccuringTotal: reoccuringTotal, remainderAmount: remainderAmount)
        🐶(fetchedBudget)
    } // End of fetch budget
    
    
    // Income
    func fetchAndCalculateIncome() {
        var incomeTotal: Double = 0
        /// This will calculate based on all of the income tab money and return a single monthly value
        IncomeController.sharedInstance.fetchIncomes { fetchedIncomes in
            for income in fetchedIncomes {
                let incomePerHour = income.amountPerHour
                let incomePerMonth = convertHourlyToOtherRate(hourlyRate: incomePerHour, desiredRate: .month)
                incomeTotal += incomePerMonth
            }
        } // End of Fetch Income
        
        self.incomeTotal = incomeTotal
    } // End of Fetch and calculate income
    
    
    // Saving
    func fetchAndCalculateSaving() {
        /// This will calculate how much money based on percent of income and natural savings per month, how much money we save
        var totalMonthAmountSaved: Double = 0
        
        SavingController.sharedInstance.fetchSavings { fetchedSavings in
            for saving in fetchedSavings {
                let saving: Saving = saving
                let frequency: FilterBy = (saving.frequency?.formatToFilterBy())!
                
                let hourlySaving = saving.amount.convertToHourlyRate(currentRate: frequency)
                let monthlySaving = convertHourlyToOtherRate(hourlyRate: hourlySaving, desiredRate: .month)
                
                switch saving.isPercent {
                case true:
                    let incomeTotal = self.incomeTotal
                    let monthlySavingPercent = ( monthlySaving / 100 )
                    
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
                let frequency: FilterBy = (expense.frequency?.formatToFilterBy())!
                
                let hourlyExpense = expense.amount.convertToHourlyRate(currentRate: frequency)
                let monthlyExpense = convertHourlyToOtherRate(hourlyRate: hourlyExpense, desiredRate: .month)
                
                totalExpenses += monthlyExpense
            } // End of Loop
            
            self.reoccuringTotal = totalExpenses
        } // End of fetch function
    } // End of Function
    
    
    // Remainder calculate
    func calculateRemainder() {
        let income = self.incomeTotal
        let saving = self.savingTotal
        let expense = self.reoccuringTotal
        
        let finalRemainder = ( income - saving - expense )
        self.remainderAmount = finalRemainder
    } // End of calculate remainder
    
    
} // End of Class
