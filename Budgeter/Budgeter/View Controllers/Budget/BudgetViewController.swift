//
//  BudgetViewController.swift
//  Budgeter
//
//  Created by Ethan Andersen on 9/3/21.
//

import UIKit

class BudgetViewController: UIViewController {

    // MARK: - Outlets
    // Value Labels
    @IBOutlet weak var totalIncomeLabel: UILabel!
    @IBOutlet weak var reoccuringTotalLabel: UILabel!
    @IBOutlet weak var savingAmountLabel: UILabel!
    @IBOutlet weak var purchaseAmountLabel: UILabel!
    @IBOutlet weak var remainderAmountLabel: UILabel!
    
    // Other Outlets
    @IBOutlet weak var purchaseFilterSwitch: UISegmentedControl!
    @IBOutlet weak var budgetTable: UITableView!
    
    
    // MARK: - Properties
    var purchases: [Purchase] = []
    var purchasesData: [Purchase] = []

    var budget: Budget?
    
    var filteredBy: FilterBy = .month
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        purchaseFilterSwitch.selectedSegmentIndex = 2
        
        budgetTable.delegate = self
        budgetTable.dataSource = self
        
        updateView()
    } // End of View did load

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateView()
    }
    
    // MARK: - Functions
    func updateView() {
        fetchPurchases()
        fetchBudget()
        filterPurchasesData()
        updateBudgetData()
        
        budgetTable.reloadData()
    } // End of Update View
    
    func fetchPurchases() {
        PurchaseController.sharedInstance.fetchPurchases { fetchedPurchases in
            self.purchases = []
            self.purchases = fetchedPurchases
        }
    } // End of Fetch Purchases
    
    func fetchBudget() {
        BudgetController.sharedInstance.fetchBudget(frequency: filteredBy) { fetchedBudget in
            self.budget = nil
            self.budget = fetchedBudget
        }
    } // End of Fetch budget

    
    func updateBudgetData() {
        let budget = filterBudgetData()
        
        let totalIncome: String = budget.incomeTotal.formatDoubleToMoneyString()
        let reoccuringTotal: String = budget.reoccuringTotal.formatDoubleToMoneyString()
        let savingAmount: String = budget.savingTotal.formatDoubleToMoneyString()
        let remainderAmount: String = (budget.remainderAmount?.formatDoubleToMoneyString())!
        
        filterPurchasesData()
        let purchaseAmount: String = calculatePurchasesAmount().formatDoubleToMoneyString()
        
        totalIncomeLabel.text = totalIncome
        reoccuringTotalLabel.text = reoccuringTotal
        savingAmountLabel.text = savingAmount
        purchaseAmountLabel.text = purchaseAmount
        remainderAmountLabel.text = remainderAmount
    } // End of Update budget
    
    func filterPurchasesData() {
        let purchaseArray = self.purchases
        let filterBy = filteredBy
        
        self.purchasesData = sortPurchasesByTimeArray(arrayToFilter: purchaseArray, filterBy: filterBy)
        
        budgetTable.reloadData()
    } // End of Filter data
    
    
    func updateBudgetDataBySorted() {
        // Make the whole stack view hidden, only show the cells
    } // End of Function
    
    func filterBudgetData() -> Budget {
        let budget = self.budget!
        var desiredRate: FilterBy = filteredBy
        
        switch filteredBy {
        case .sorted:
            print("Is line \(#line) working?")
        case .hour:
            print("Is line \(#line) working?")
        case .day:
            desiredRate = .day
        case .week:
            desiredRate = .week
        case .month:
            desiredRate = .month
        case .year:
            desiredRate = .year
        }
        
        let incomeTotal = convertMonthlyRateToOtherRate(monthlyRate: budget.incomeTotal, desiredRate: desiredRate)
        let remainderAmount = convertMonthlyRateToOtherRate(monthlyRate: budget.remainderAmount!, desiredRate: desiredRate)
        let reoccuringTotal = convertMonthlyRateToOtherRate(monthlyRate: budget.reoccuringTotal, desiredRate: desiredRate)
        let savingTotal = convertMonthlyRateToOtherRate(monthlyRate: budget.savingTotal, desiredRate: desiredRate)
        
        let filteredBudget = Budget(incomeTotal: incomeTotal, savingTotal: savingTotal, reoccuringTotal: reoccuringTotal, remainderAmount: remainderAmount)
        
        return filteredBudget
    } // End of Filter budget data
    
    func updateData() {
        if filteredBy == .sorted {
            updateBudgetDataBySorted()
        } else {
            updateBudgetData()
        }
        
        filterPurchasesData()
    } // End of Update data
    
    // MARK: - Actions
    @IBAction func segmentDidChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            filteredBy = .day
        case 1:
            filteredBy = .week
        case 2:
            filteredBy = .month
        case 3:
            filteredBy = .year
        case 4:
            filteredBy = .sorted
        default:
            print("Is line \(#line) working?")
        }
        
        updateData()
    } // End of Segment did  change

    func calculatePurchasesAmount() -> Double {
        let filteredPurchases: [Purchase] = purchasesData
        var purchaseTotal: Double = 0
        
        for purchase in filteredPurchases {
            purchaseTotal += purchase.amount
        } // End of For loop
        
        return purchaseTotal
    } // End of Function

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toExpenseDetailVC" {
            guard let destinationVC = segue.destination as? PurchaseDetailViewController,
                  let indexPath = budgetTable.indexPathForSelectedRow else { return }
            
            let purchase = purchasesData[indexPath.row]
            destinationVC.purchase = purchase
        }
    } // End of Segue
    
} // End of Class


// MARK: - Extensions
extension BudgetViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Number of cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return purchasesData.count
    } // End of Number of cells
    
    // Cell data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "purchaseCell", for: indexPath) as? BudgetTableViewCell
        let purchase = purchasesData[indexPath.row]
        
        cell?.purchase = purchase
        
        return cell ?? BudgetTableViewCell()
    } // End of Cell Data
    
    // Delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let purchaseToDelete = purchasesData[indexPath.row]
            PurchaseController.sharedInstance.deletePurchase(purchaseToDelete: purchaseToDelete)
            
            updateView()
        }
    } // End of Delete
    
} // End of Extension
