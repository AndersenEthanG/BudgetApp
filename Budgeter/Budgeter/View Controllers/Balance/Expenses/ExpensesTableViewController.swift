//
//  ExpensesTableViewController.swift
//  Budgeter
//
//  Created by Ethan Andersen on 9/3/21.
//

import UIKit

class ExpenseViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var expensesLabel: UILabel!
    @IBOutlet weak var segmentedController: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Properties
    var expenses: [Expense] = []
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        fetchExpenses()
    } // End of View did load

    
    // MARK: - Functions
    func fetchExpenses() {
        ExpenseController.sharedInstance.fetchExpenses { fetchedExpenses in
            self.expenses = []
            self.expenses = fetchedExpenses
            
            self.updateView()
        }
    } // End of Fetch Expenses

    
    func updateView() {
        
    } // End of Update View
    
} // End of Expense View Controller


// MARK: - Extensions
extension ExpenseViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - Table view data source
    // Number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count
    } // End of Number of rows
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "incomeCell", for: indexPath)
        let expense = expenses[indexPath.row]
        
        cell.textLabel?.text = expense.name
        
        var detail1 = expense.amount.formatDoubleToMoneyString()
        let detail2 = ( " per " + expense.frequency! )

        if expense.isPercent == true {
            detail1 = expense.amount.formatToPercent()
        }
        
        cell.detailTextLabel?.text = ( detail1 + detail2 )
        
        return cell
    } // End of Cell data
    
    // Delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let expenseToDelete = expenses[indexPath.row]
            
            ExpenseController.sharedInstance.deleteExpense(expenseToDelete: expenseToDelete)
            
            fetchExpenses()
        }
    } // End of Delete
    
} // End of table view Extension
