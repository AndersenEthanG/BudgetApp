//
//  ExpensesViewController.swift
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchExpenses()
    } // End of View will appear
    
    
    // MARK: - Functions
    func fetchExpenses() {
        ExpenseController.sharedInstance.fetchExpenses { fetchedExpenses in
            self.expenses = []
            self.expenses = fetchedExpenses
            
            self.updateView()
        }
    } // End of Fetch Expenses
    
    func updateView() {
        updateExpensesLabel()
        tableView.reloadData()
    } // End of Update View
    
    func updateExpensesLabel() {
        var finalNumber: Double = 0
        for expense in expenses {
            finalNumber += expense.amount
        }
        
        expensesLabel.text = finalNumber.formatDoubleToMoneyString()
    } // End of Update expenses label
    
    
} // End of Expense View Controller


// MARK: - Extensions
extension ExpenseViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - Table view data source
    // Number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count
    } // End of Number of rows
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "expenseCell", for: indexPath)
        let expense = expenses[indexPath.row]
        
        cell.textLabel?.text = expense.name
        
        let detail1 = expense.amount.formatDoubleToMoneyString()
        let detail2 = expense.frequency!
        
        cell.detailTextLabel?.text = ( detail1 + " per " + detail2 )
        
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
