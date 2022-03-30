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
    @IBOutlet weak var filterByButton: UIButton!
    
    
    // MARK: - Properties
    var expenses: [Expense] = []
    var filteredExpenses: [Expense] = []
    var segmentIndex: FilterBy = .month
    var sortBy: SortBy = .byValueDescending
    var paymentSource: String = "All"
    
    
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
            
            self.filterExpensesBySource(paymentSource: self.paymentSource)
        }
    } // End of Fetch Expenses
    
    func updateView() {
        updateSortBy()
        sortExpenses(sortBy: self.sortBy)
        tableView.reloadData()
    } // End of Update View
    
    func updateExpensesLabel(filterBy: FilterBy) {
        var finalNumber: Double = 0
        
        for expense in filteredExpenses {
            let rate = expense.amount
            let currentRate: FilterBy = (expense.frequency?.formatToFilterBy())!
            let desiredRate = filterBy
            
            let result = convertRate(rate: rate, currentRate: currentRate, desiredRate: desiredRate)
                
            finalNumber += result
        } // End of Loop
        
        let preText = "Total Expenses: "
        expensesLabel.text = ( preText + finalNumber.formatDoubleToMoneyString() )
    } // End of Update expenses label
    
    func updateSortBy() {
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
            filteredExpenses.sort {
                convertRate(rate: $0.amount, currentRate: ($0.frequency?.formatToFilterBy())!, desiredRate: .year) < convertRate(rate: $1.amount, currentRate: ($1.frequency?.formatToFilterBy())!, desiredRate: .year)
            }
            self.sortByButton.setTitle("Sort By: Ascending", for: .normal)
        case .byValueDescending:
            filteredExpenses.sort {
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
    
    func filterExpensesBySource(paymentSource: String) {
        var selectedExpenses: [Expense] = []
        
        for expense in expenses {
            if expense.paymentSource == paymentSource || paymentSource == "All" {
                    selectedExpenses.append(expense)
            }
        } // End of Loop
        
        self.filteredExpenses = selectedExpenses
        
        filterByButton.setTitle("Filter By: \(paymentSource)", for: .normal)
        
        updateView()
    } // End of filter expenses
    
    
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
    
    
    @IBAction func filterByBtn(_ sender: Any) {
        let alert = UIAlertController(title: "Filter By", message: "Select which payment source you want to see ", preferredStyle: .actionSheet)
                
        // Normal actions
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let allAction = UIAlertAction(title: "All", style: .destructive) { action in
            let selectedPaymentSource = "All"
            self.filterExpensesBySource(paymentSource: selectedPaymentSource)
        }
        alert.addAction(allAction)
        
        
        var duplicationCheck: [String] = []
        // Get all the payment source options
        for expense in self.expenses {
            let paymentSource = expense.paymentSource
            
            if !duplicationCheck.contains(paymentSource!) && paymentSource != "" && paymentSource != nil {
                
                duplicationCheck.append(paymentSource!)
                
                let newAction = UIAlertAction(title: paymentSource, style: .default) { action in
                    let selectedPaymentSource = paymentSource!
                    
                    self.paymentSource = selectedPaymentSource
                    self.filterExpensesBySource(paymentSource: selectedPaymentSource)
                } // End of New action
                
                alert.addAction(newAction)
            } // End of duplication check
            
        } // End of Loop
        
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    } // End of Filter by Button
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toExpenseDetailVC" {
            guard let destinationVC = segue.destination as? ExpenseDetailViewController,
                  let indexPath = tableView.indexPathForSelectedRow else { return }
            
            // Data
            let expense = filteredExpenses[indexPath.row]
            
            // Set data
            destinationVC.expense = expense
        }
    } // End of Segue
    
} // End of Expense View Controller


// MARK: - Table View Extension
extension ExpenseViewController: UITableViewDelegate, UITableViewDataSource {
    // Number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredExpenses.count
    } // End of Number of rows
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "expenseCell", for: indexPath) as? ExpenseTableViewCell else { return ExpenseTableViewCell() }
        let expense = filteredExpenses[indexPath.row]
        
        cell.expense = expense
        
        return cell
    } // End of Cell data
    
    // Delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let expenseToDelete = filteredExpenses[indexPath.row]
            
            ExpenseController.sharedInstance.deleteExpense(expenseToDelete: expenseToDelete)
            
            fetchExpenses()
        }
    } // End of Delete

} // End of table view Extension
