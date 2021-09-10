//
//  ExpensesDetailViewController.swift
//  Budgeter
//
//  Created by Ethan Andersen on 9/3/21.
//

import UIKit

class ExpenseDetailViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var segmentedController: UISegmentedControl!
    
    
    // MARK: - Properties
    var expense: Expense?
    var frequency: FilterBy = .week
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView()
    } // End of View did load
    
    
    // MARK: - Functions
    func updateView() {
        if let expense = self.expense {
            navigationItem.title = "Edit Expense"
            nameField.text = expense.name
            amountField.text = expense.amount.formatDoubleToMoneyString()
            frequency = (expense.frequency?.formatToFilterBy())!
        }
    } // End of Update view
    
    
    // MARK: - Actions
    @IBAction func saveBtn(_ sender: Any) {
        // Get values
        let amount: Double = (amountField.text?.formatToDouble())!
        let frequency: String = frequency.formatToString()
        let name = nameField.text ?? "New Expense"
        let updateDate = Date()
        
        if let expense = self.expense {
            // Delete
            ExpenseController.sharedInstance.deleteExpense(expenseToDelete: expense)
            
            // Update
            self.expense = Expense(amount: amount, frequency: frequency, name: name, updateDate: updateDate)
        } else {
            // Save
            let newExpense = Expense(amount: amount, frequency: frequency, name: name, updateDate: updateDate)
            ExpenseController.sharedInstance.createExpense(newExpense: newExpense)
        }
        
        navigationController?.popViewController(animated: true)
    } // End of Save button
    
    
    @IBAction func segmentDidChange(_ sender: Any) {
        var newFrequency: FilterBy = .week
        
        switch segmentedController.selectedSegmentIndex {
        case 0:
            // Week
            newFrequency = .week
        case 1:
            // Month
            newFrequency = .month
        case 2:
            // Year
            newFrequency = .year
        default:
            print("Is line \(#line) working?")
        }
        
        frequency = newFrequency
    } // End of Segment did change
    
} // End of Expense Detail
