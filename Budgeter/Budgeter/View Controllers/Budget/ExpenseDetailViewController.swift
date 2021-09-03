//
//  NewExpenseViewController.swift
//  Budgeter
//
//  Created by Ethan Andersen on 9/3/21.
//

import UIKit

class ExpenseDetailViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var expenseNameLabel: UITextField!
    @IBOutlet weak var expenseAmountLabel: UITextField!
    @IBOutlet weak var expenseDatePicker: UIDatePicker!
    
    
    // MARK: - Properties
//    var expense: Expense?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    } // End of View did load

    
    // MARK: - Actions
    @IBAction func saveBtn(_ sender: Any) {
        
    } // End of Save Button
    
} // End of Class
