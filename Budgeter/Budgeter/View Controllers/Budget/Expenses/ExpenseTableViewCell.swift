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
    @IBOutlet weak var expensePaymentDateLabel: UILabel!
    @IBOutlet weak var expensePaymentSouceLabel: UILabel!
    
    
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
        updateExpensePaymentDateLabel()
        updateExpensePaymentSourceLabel()
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

        let finalText: String = ( String(format: "%.2f", calculatedAmount) + "% of total income" )

        expensePercentLabel.text = finalText
    } // End of Function
    
    func updateExpensePaymentDateLabel() {
        guard let expense = expense else { return }

        if expense.paymentDate == "" || expense.paymentDate == nil || expense.paymentDate == "none" {
            expensePaymentDateLabel.text = ""
            expensePaymentDateLabel.isHidden = true
        } else {
            expensePaymentDateLabel.text = ("Due Date: " + expense.paymentDate!)
            expensePaymentDateLabel.isHidden = false
        }
    } // End of Update payment date label
    
    func updateExpensePaymentSourceLabel() {
        guard let expense = expense else { return }

        if expense.paymentSource == "" || expense.paymentSource == nil {
            expensePaymentSouceLabel.text = ""
            expensePaymentSouceLabel.isHidden = true
        } else {
            expensePaymentSouceLabel.text = expense.paymentSource!
            expensePaymentSouceLabel.isHidden = false
        }
    } // End of Update expense source label
} // End of Expense table view cell
