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
    @IBOutlet weak var percentOrFixedLabel: UILabel!
    @IBOutlet weak var isPercentSwitch: UISwitch!
    @IBOutlet weak var segmentedController: UISegmentedControl!
    
    
    // MARK: - Properties
    var expense: Expense?
    var isPercent: Bool = true
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
            formatAmount()
            isPercent = expense.isPercent
            frequency = (expense.frequency?.formatToFilterBy())!
        }
    } // End of Update view

    func formatAmount() {
        var finalResult: String = (expense?.amount.formatDoubleToMoneyString())!
        
        if expense?.isPercent == true {
            finalResult = (expense?.amount.formatToPercent())!
        }
        
        amountField.text = finalResult
    } // End of Format Amount
    
    // MARK: - Actions
    @IBAction func saveBtn(_ sender: Any) {
        
    } // End of Save button
    
    @IBAction func isPercentToggle(_ sender: Any) {
    } // End of Switch toggle
    
    
    @IBAction func segmentDidChange(_ sender: Any) {
    }
    
} // End of Expense Detail
