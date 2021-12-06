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
    @IBOutlet weak var sortByButton: UIButton!
    
    
    // MARK: - Properties
    var expenses: [Expense] = []
    var segmentIndex: FilterBy = .month
    var sortBy: SortBy = .byValueDescending
    
    
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
        sortExpenses(sortBy: self.sortBy)
        tableView.reloadData()
    } // End of Update View
    
    func updateExpensesLabel(filterBy: FilterBy) {
        var finalNumber: Double = 0
        
        for expense in expenses {
            let rate = expense.amount
            let currentRate: FilterBy = (expense.frequency?.formatToFilterBy())!
            let desiredRate = filterBy
            
            let result = convertRate(rate: rate, currentRate: currentRate, desiredRate: desiredRate)
                
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
    
    func sortExpenses(sortBy: SortBy) {
        switch sortBy {
        case .byValueAscending:
            expenses.sort {
                convertRate(rate: $0.amount, currentRate: ($0.frequency?.formatToFilterBy())!, desiredRate: .year) < convertRate(rate: $1.amount, currentRate: ($1.frequency?.formatToFilterBy())!, desiredRate: .year)
            }
            self.sortByButton.setTitle("Sort By: Ascending", for: .normal)
        case .byValueDescending:
            expenses.sort {
                convertRate(rate: $0.amount, currentRate: ($0.frequency?.formatToFilterBy())!, desiredRate: .year) > convertRate(rate: $1.amount, currentRate: ($1.frequency?.formatToFilterBy())!, desiredRate: .year)
            }
            self.sortByButton.setTitle("Sort By: Descending", for: .normal)
        case .alphabetically:
            //TODO(ethan) Figure out how to sort strings
            print("Is line \(#line) working?")
        } // End of Switch
        
        updateSortByButton()
    } // End of Sort data
    
    func updateSortByButton() {
        var updatedTitle: String = ""
        switch sortBy {
        case .byValueAscending:
            updatedTitle = "Sort By: Ascending"
        case .byValueDescending:
            updatedTitle = "Sort By: Descending"
        case .alphabetically:
            updatedTitle = "Sort: Alphabetically"
        }
        sortByButton.titleLabel?.text = updatedTitle
    } // End of update filter by button Function
    
    
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
    
    
    @IBAction func sortByBtn(_ sender: Any) {
        if self.sortBy == .byValueAscending {
            self.sortBy = .byValueDescending
        } else if self.sortBy == .byValueDescending {
            self.sortBy = .byValueAscending
        }
        updateView()
    } // End of Sort By Button
    
    
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "expenseCell", for: indexPath) as? ExpenseTableViewCell else { return ExpenseTableViewCell() }
        let expense = expenses[indexPath.row]
        
        cell.expense = expense
        
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
