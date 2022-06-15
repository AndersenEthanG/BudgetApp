//
//  ExpensesViewController.swift
//  Budgeter
//
//  Created by Ethan Andersen on 9/3/21.
//

import UIKit
import ViewAnimator

class ExpenseViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var topHalfStack: UIStackView!
    @IBOutlet weak var expenseTotalLabel: UILabel!
    @IBOutlet weak var expenseTotalSegmentedContoller: UISegmentedControl!
    @IBOutlet weak var filterByButton: UIButton!
    @IBOutlet weak var sortByButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var expensesOriginal: [Expense] = []
    var expensesToDisplay: [Expense] = []
    var expenseTotalSegmentIndex = 1
    var expenseTotalSegmentFilterByType: FilterBy = .month
    var filterByPaymentSourceText: String = "All"
    var sortByValue: SortBy = .byValueDescending
    var searchText: String = ""
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        // View Animator stuff
        topHalfStack.animate(animations: [AnimationType.from(direction: .right, offset: 300)], duration: 0.7)
        
        let animation = AnimationType.from(direction: .right, offset: 300)
        UIView.animate(views: tableView.visibleCells, animations: [animation], duration: 1)
        
        fetchExpenses()
        loadDataAndView()
    } // End of View did load
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchExpenses()
        loadDataAndView()
    } // End of view will appear
    
    
    // MARK: - Functions
    func loadDataAndView() {
        self.expensesToDisplay = self.expensesOriginal
        
        updateExpenses()
        updateView()
    } // End of reload data and view
    
    func fetchExpenses() {
        ExpenseController.sharedInstance.fetchExpenses { fetchedExpenses in
            self.expensesOriginal = []
            self.expensesOriginal = fetchedExpenses
            
            self.expensesToDisplay = self.expensesOriginal
        }
    } // End of fetch expenses
    
    func updateExpenses() {
        filterByPaymentSource()
        filterBySortBy()
        filterBySearchTerms()
    } // End of update expenses
    
    func filterByPaymentSource() {
        let paymentSource = self.filterByPaymentSourceText
        var selectedExpenses: [Expense] = []
        
        for expense in self.expensesToDisplay {
            if expense.paymentSource == paymentSource || paymentSource == "All" {
                selectedExpenses.append(expense)
            }
        } // End of Loop
        
        expensesToDisplay = selectedExpenses
    } // End of filter by payment source
    
    func filterBySortBy() {
        let sortBy = self.sortByValue
        
        switch sortBy {
        case .byValueAscending:
            expensesToDisplay.sort {
                convertRate(rate: $0.amount, currentRate: ($0.frequency?.formatToFilterBy())!, desiredRate: .year) < convertRate(rate: $1.amount, currentRate: ($1.frequency?.formatToFilterBy())!, desiredRate: .year)
            }
            // End of by value ascending
            
        case .byValueDescending:
            expensesToDisplay.sort {
                convertRate(rate: $0.amount, currentRate: ($0.frequency?.formatToFilterBy())!, desiredRate: .year) > convertRate(rate: $1.amount, currentRate: ($1.frequency?.formatToFilterBy())!, desiredRate: .year)
            }
            // End of By value descending
            
        case .alphabetically:
            // This isn't an option
            print("Is line \(#line) working?")
            // End of Alphabetically
            
        case .byDateAscending:
            var sortedExpenses: [Expense] = []
            for expense in expensesToDisplay {
                if expense.paymentDate != "" && expense.paymentDate != "none" && expense.paymentDate != nil {
                    sortedExpenses.append(expense)
                }
                
                sortedExpenses.sort {
                    ($0.paymentDate!.turnPaymentDateToInt()) < ($1.paymentDate!.turnPaymentDateToInt())
                }
                
                self.expensesToDisplay = sortedExpenses
            }
            // End of By Date Ascending
            
        case .byDateDescending:
            var sortedExpenses: [Expense] = []
            for expense in expensesToDisplay {
                if expense.paymentDate != "" && expense.paymentDate != "none" && expense.paymentDate != nil {
                    sortedExpenses.append(expense)
                }
                
                sortedExpenses.sort {
                    ($0.paymentDate!.turnPaymentDateToInt()) > ($1.paymentDate!.turnPaymentDateToInt())
                }
                
                self.expensesToDisplay = sortedExpenses
            }
            // End of by Date descending
        } // End of Sort by
    } // End of filter by sort by
    
    func filterBySearchTerms() {
        let searchText = self.searchText
        var searchedExpenses: [Expense] = []
        
        if searchText == "" {
            searchedExpenses = self.expensesToDisplay
            self.expensesToDisplay = searchedExpenses
        } else {
            for expense in expensesToDisplay {
                if String(expense.amount).lowercased().contains(searchText) == true ||
                    expense.paymentSource?.lowercased().contains(searchText) == true ||
                    expense.frequency?.lowercased().contains(searchText) == true ||
                    expense.name?.lowercased().contains(searchText) == true ||
                    expense.paymentDate?.lowercased().contains(searchText) == true {
                    
                    searchedExpenses.append(expense)
                } // End of object search If Conditions
            } // End of Loop
            
            self.expensesToDisplay = searchedExpenses
        } // End of Else search has text
    } // End of filter by search terms
    
    func updateView() {
        updateTotalExpenseLabel()
        expenseTotalSegmentedContoller.selectedSegmentIndex = expenseTotalSegmentIndex
        filterByButton.setTitle("Filter By: \(self.filterByPaymentSourceText)", for: .normal)
        updateSortByButton()
        tableView.reloadData()
    } // End of update view
    
    func updateTotalExpenseLabel() {
        let filterBy = self.expenseTotalSegmentFilterByType
        var finalNumber: Double = 0
        
        for expense in expensesToDisplay {
            let rate = expense.amount
            let currentRate: FilterBy = (expense.frequency?.formatToFilterBy())!
            let desiredRate = filterBy
            
            let result = convertRate(rate: rate, currentRate: currentRate, desiredRate: desiredRate)
            
            finalNumber += result
        } // End of loop
        
        let preText = "Total Expenses: "
        expenseTotalLabel.text = (preText + finalNumber.formatDoubleToMoneyString())
        
    } // End of update total expense label
    
    func updateSortByButton() {
        var updatedTitle: String = ""
        switch sortByValue {
        case .byValueAscending:
            updatedTitle = "Sort By: Amount Asc."
        case .byValueDescending:
            updatedTitle = "Sort By: Amount Desc."
        case .alphabetically:
            updatedTitle = "Sort By: Alphabetically"
        case .byDateAscending:
            updatedTitle = "Sort By: Date Asc."
        case .byDateDescending:
            updatedTitle = "Sort By: Date Desc."
        }
        sortByButton.setTitle(updatedTitle, for: .normal)
    } // End of update sort by button
    
    
    // MARK: - Actions
    @IBAction func expenseTotalSegmentedControllerDidChange(_ sender: Any) {
        var returnIndexValue: FilterBy = expenseTotalSegmentFilterByType
        
        switch expenseTotalSegmentedContoller.selectedSegmentIndex {
        case 0:
            returnIndexValue = .week
        case 1:
            returnIndexValue = .month
        case 2:
            returnIndexValue = .year
        default:
            print("Is line \(#line) working?")
        } // End of Switch
        
        self.expenseTotalSegmentFilterByType = returnIndexValue
        updateTotalExpenseLabel()
    } // End of seg controller did change
    
    @IBAction func filterByBtnTap(_ sender: Any) {
        let alert = UIAlertController(title: "Filter By Payment Source", message: "Select which payment source you want to see ", preferredStyle: .actionSheet)
        
        // Normal actions
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let allAction = UIAlertAction(title: "All", style: .destructive) { action in
            self.filterByPaymentSourceText = "All"
            self.loadDataAndView()
        }
        alert.addAction(allAction)
        
        
        var duplicationCheck: [String] = []
        
        // Get all the payment source options
        for expense in self.expensesOriginal {
            let paymentSource = expense.paymentSource
            
            if !duplicationCheck.contains(paymentSource!) && paymentSource != "" && paymentSource != nil {
                
                duplicationCheck.append(paymentSource!)
                
                let newAction = UIAlertAction(title: paymentSource, style: .default) { action in
                    let selectedPaymentSource = paymentSource!
                    
                    self.filterByPaymentSourceText = selectedPaymentSource
                    
                    // Update everything
                    self.loadDataAndView()
                } // End of New action
                
                alert.addAction(newAction)
            } // End of duplication check
            
        } // End of Loop
        
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    } // End of Filter by button tapped
    
    @IBAction func sortByBtnTap(_ sender: Any) {
        let alert = UIAlertController(title: "Sort By", message: "How would you like to sort your expenses?", preferredStyle: .actionSheet)
        
        let valueDescendingAction = UIAlertAction(title: "Amount Desc.", style: .default) { action in
            self.sortByValue = .byValueDescending
            self.loadDataAndView()
        }
        alert.addAction(valueDescendingAction)
        
        let valueAscendingAction = UIAlertAction(title: "Amount Asc.", style: .default) { action in
            self.sortByValue = .byValueAscending
            self.loadDataAndView()
        }
        alert.addAction(valueAscendingAction)
        
        let dateDescendingAction = UIAlertAction(title: "Date Desc.", style: .default) { action in
            self.sortByValue = .byDateDescending
            self.loadDataAndView()
        }
        alert.addAction(dateDescendingAction)
        
        let dateAscendingAction = UIAlertAction(title: "Date Asc.", style: .default) { action in
            self.sortByValue = .byDateAscending
            self.loadDataAndView()
        }
        alert.addAction(dateAscendingAction)
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        navigationController?.present(alert, animated: true, completion: nil)
    } // End of Sort by button tapped
    
    
    // MARK: - Keyboard things
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    } // End of Touches began
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toExpenseDetailVC" {
            guard let destinationVC = segue.destination as? ExpenseDetailViewController,
                  let indexPath = tableView.indexPathForSelectedRow else { return }
            
            // Data
            let expense = expensesToDisplay[indexPath.row]
            
            // Set data
            destinationVC.expense = expense
        }
    } // End of Segue
    
} // End of View Controller

// MARK: - Search bar extension
extension ExpenseViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchText = searchText.lowercased()
        
        self.searchText = searchText
        
        filterBySearchTerms()
        loadDataAndView()
    } // End of Text did change

} // End of Search Bar Delegate Extension


// MARK: - Table View Extension
extension ExpenseViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expensesToDisplay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "expenseCell", for: indexPath) as? ExpenseTableViewCell else { return ExpenseTableViewCell() }
        
        let expense = expensesToDisplay[indexPath.row]
        
        cell.expense = expense
        
        return cell
    } // End of Cell for row at
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let expenseToDelete = expensesToDisplay[indexPath.row]
            
            ExpenseController.sharedInstance.deleteExpense(expenseToDelete: expenseToDelete)
            
            fetchExpenses()
            loadDataAndView()
        }
    } // End of Delete row
} // End of Extension
