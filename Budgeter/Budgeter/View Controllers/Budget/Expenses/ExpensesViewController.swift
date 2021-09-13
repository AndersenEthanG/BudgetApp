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
    var segmentIndex: FilterBy = .month
    
    
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
        updateFilterBy()
        tableView.reloadData()
    } // End of Update View
    
    func updateExpensesLabel(filterBy: FilterBy) {
        var finalNumber: Double = 0
        
        for expense in expenses {
            var result = expense.amount.convertToHourlyRate(currentRate: (expense.frequency?.formatToFilterBy())!)
            result = convertHourlyToOtherRate(hourlyRate: result, desiredRate: segmentIndex)
                
            finalNumber += result
        } // End of Loop
        
        let preText = "Total Expenses: "
        expensesLabel.text = ( preText + finalNumber.formatDoubleToMoneyString() )
    } // End of Update expenses label
    
    func updateFilterBy() {
        var finalFilter: FilterBy = segmentIndex
        
        switch segmentIndex {
        case .sorted:
            print("Is line \(#line) working?")
        case .hour:
            print("Is line \(#line) working?")
        case .day:
            print("Is line \(#line) working?")
        case .week:
            finalFilter = .week
        case .month:
            finalFilter = .month
        case .year:
            finalFilter = .year
        } // End of Switch
        
        updateExpensesLabel(filterBy: finalFilter)
    } // End of Update filter by
    
    
    // MARK: - Actions
    @IBAction func segmentDidChange(_ sender: Any) {
        var finalIndex: FilterBy = segmentIndex
        
        switch segmentedController.selectedSegmentIndex {
        case 0:
            // Week
            finalIndex = .week
        case 1:
            // Month
            finalIndex = .month
        case 2:
            // Year
            finalIndex = .year
        default:
            print("Is line \(#line) working?")
        } // End of Switch
        
        segmentIndex = finalIndex
        updateView()
    } // End of Segment did change
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toExpenseDetailVC" {
            guard let destinationVC = segue.destination as? ExpenseDetailViewController,
                  let indexPath = tableView.indexPathForSelectedRow else { return }
            
            // Data
            let expense = expenses[indexPath.row]
            
            // Set data
            destinationVC.expense = expense
        }
    } // End of Segue
    
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
