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
    @IBOutlet weak var searchBar: UISearchBar!
    
    
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
        
        searchBar.delegate = self
        
        setupKeyboard()
        
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
        let alert = UIAlertController(title: "Filter By Payment Source", message: "Select which payment source you want to see ", preferredStyle: .actionSheet)
        
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
    
    
    // MARK: - Keyboard things
    func setupKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(ExpenseViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ExpenseViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.sizeToFit()
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(image: UIImage(systemName: "keyboard.chevron.compact.down"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.keyboardWillHide(notification:)))
        toolBar.setItems([spaceButton, doneButton], animated: false)
        
        searchBar.inputAccessoryView = toolBar
    } // End of Setup keyboard
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        segmentedController.isEnabled = false
        sortByButton.isEnabled = false
        filterByButton.isEnabled = false
        tableView.isUserInteractionEnabled = false
    } // End of keyboard will show
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.endEditing(true)
        
        segmentedController.isEnabled = true
        sortByButton.isEnabled = true
        filterByButton.isEnabled = true
        tableView.isUserInteractionEnabled = true
        
        if searchBar.text == "" {
            self.filteredExpenses = expenses
            updateView()
        }
    } // End of Keyboard will hide
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
        if searchBar.text == "" {
            self.filteredExpenses = expenses
            updateView()
        }
    } // End of Touches began
    
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


// MARK: - Search Bar extension
extension ExpenseViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchText = searchText.lowercased()
        
        // Filter set to all
        let selectedPaymentSource = "All"
        filterExpensesBySource(paymentSource: selectedPaymentSource)
        
        if searchText == "" {
            self.filteredExpenses = expenses
        } else {
            
            var selectedExpenses: [Expense] = []
            
            // Go through all of the text of all of the expenses to check for a match
            for expense in self.expenses {
                if String(expense.amount).lowercased().contains(searchText) == true ||
                    expense.paymentSource?.lowercased().contains(searchText) == true ||
                    expense.frequency?.lowercased().contains(searchText) == true ||
                    expense.name?.lowercased().contains(searchText) == true ||
                    expense.paymentDate?.lowercased().contains(searchText) == true {
                    
                    // Append to the new array
                    selectedExpenses.append(expense)
                } // End of Big if statement
            } // End of Loop
            self.filteredExpenses = selectedExpenses
        } // End of if the search text is blank
        
        updateView()
    } // End of text did change
} // End of Search bar extension
