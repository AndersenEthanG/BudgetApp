//
//  ExpenseTableViewCell.swift
//  Budgeter
//
//  Created by Ethan Andersen on 9/14/21.
//

import UIKit

class ExpenseTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var expenseTitleLabel: UILabel!
    @IBOutlet weak var expenseAmountLabel: UILabel!
    @IBOutlet weak var expensePercentLabel: UILabel!
    
    
    // MARK: - Properties
    var expense: Expense? {
        didSet {
            updateView()
        }
    } // End of Expense property
    
    
    // MARK: - Functions
    func updateView() {
        guard let expense = self.expense else { return }
        
        expenseTitleLabel.text = expense.name
        updateExpenseAmountLabel()
        updateExpensePercentLabel()
    } // End of Function
    
    func updateExpenseAmountLabel() {
        guard let expense = self.expense else { return }
        var finalText: String = ""
        
        let amount = expense.amount.formatDoubleToMoneyString()
        let frequency = expense.frequency
        
        finalText = ( amount + " per " + frequency! )
        
        expenseAmountLabel.text = finalText
    } // End of Update expense amount label

    func updateExpensePercentLabel() {
        guard let expense = self.expense else { return }
        
        let expenseAmount = expense.amount
        let totalIncome: Double = IncomeController.sharedInstance.getTotalIncome(frequency: (expense.frequency?.formatToFilterBy())!)
        
        let calculatedAmount = ( (expenseAmount / totalIncome) * 100 )

        let finalText: String = ( calculatedAmount.formatToPercent() + " of total income" )

        expensePercentLabel.text = finalText
    } // End of Function
    
} // End of Expense table view cell
