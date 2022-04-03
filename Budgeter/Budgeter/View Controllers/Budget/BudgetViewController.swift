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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topHalfStack: UIStackView!
    
    
    // MARK: - Properties
    var purchases: [Purchase] = []
    var purchasesData: [Purchase] = []
    
    var budget: Budget?
    
    var filteredBy: FilterBy = .month
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cleanDataAndView()
        
        purchaseFilterSwitch.selectedSegmentIndex = 2
        updateFilterSwitch()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchPurchases()
        fetchBudget()
        
        delayedUpdate()
    } // End of View did load
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cleanDataAndView()
        fetchPurchases()
        fetchBudget()
    } // End of View will appear
    
    
    // MARK: - Functions
    func fetchPurchases() {
        PurchaseController.sharedInstance.fetchPurchases { fetchedPurchases in
            self.purchases = []
            self.purchases = fetchedPurchases
            self.filterPurchasesData()
        }
    } // End of Fetch Purchases
    
    func fetchBudget() {
        BudgetController.sharedInstance.fetchBudget(totalPurchases: calculatePurchasesAmount()) { fetchedBudget in
            self.budget = nil
            self.budget = fetchedBudget
            self.updateBudgetData()
        }
    } // End of Fetch budget
    
    
    func updateBudgetData() {
        let budget = filterBudgetData()
        
        let totalIncome: String = budget.incomeTotal.formatDoubleToMoneyString()
        let reoccuringTotal: String = budget.reoccuringTotal.formatDoubleToMoneyString()
        let savingAmount: String = budget.savingTotal.formatDoubleToMoneyString()
        
        let rawPurchaseAmount: Double = calculatePurchasesAmount()
        let purchaseAmount: String = rawPurchaseAmount.formatDoubleToMoneyString()
        let remainderAmount: Double = calculateRemainderAmount(adjustedBudget: budget, purchaseTotal: rawPurchaseAmount)
        
        // Set the text values
        totalIncomeLabel.text = totalIncome
        reoccuringTotalLabel.text = reoccuringTotal
        savingAmountLabel.text = savingAmount
        purchaseAmountLabel.text = purchaseAmount
        remainderAmountLabel.text = remainderAmount.formatDoubleToMoneyString()
        if remainderAmount >= 0 {
            remainderAmountLabel.textColor = hexStringToUIColor(hex: CustomColors.green )
        } else {
            remainderAmountLabel.textColor = .red
        }
    } // End of Update budget
    
    func filterPurchasesData() {
        let purchaseArray = self.purchases
        let filterBy = filteredBy
        
        self.purchasesData = sortPurchasesByTimeArray(arrayToFilter: purchaseArray, filterBy: filterBy)
        sortChronologically()
        
        tableView.reloadData()
    } // End of Filter data
    
    
    func updateBudgetDataBySorted() {
        // Make the whole stack view hidden, only show the cells
    } // End of Function
    
    func filterBudgetData() -> Budget {
        let budget = self.budget!
        let currentRate = budget.rate
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
        
        let filteredBudget = convertBudget(budget: budget, currentRate: currentRate, desiredRate: desiredRate)
        
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
    
    func cleanDataAndView() {
        // Data sources
        self.purchases = []
        self.purchasesData = []
        self.budget = nil
        
        // Labels
        self.totalIncomeLabel.text = ""
        self.reoccuringTotalLabel.text = ""
        self.savingAmountLabel.text = ""
        self.purchaseAmountLabel.text = ""
        self.remainderAmountLabel.text = ""
    } // End of Clean data
    
    func updateFilterSwitch() {
        var finalIndex: Int = 0
        
        switch filteredBy {
        case .sorted:
            finalIndex = 4
        case .hour:
            print("Is line \(#line) working?")
        case .day:
            finalIndex = 0
        case .week:
            finalIndex = 1
        case .month:
            finalIndex = 2
        case .year:
            finalIndex = 3
        } // End of Switch
        
        purchaseFilterSwitch.selectedSegmentIndex = finalIndex
    } // End of Update filter switch
    
    func calculatePurchasesAmount() -> Double {
        filterPurchasesData()
        
        let filteredPurchases: [Purchase] = purchasesData
        var purchaseTotal: Double = 0
        
        for purchase in filteredPurchases {
            purchaseTotal += purchase.amount
        } // End of For loop
        
        return purchaseTotal
    } // End of Function
    
    
    func calculateRemainderAmount(adjustedBudget: Budget, purchaseTotal: Double) -> Double {
        let income = adjustedBudget.incomeTotal
        let savings = adjustedBudget.savingTotal
        let expenses = adjustedBudget.reoccuringTotal
        let purchases = purchaseTotal
        
        let finalRemainder: Double = ( income - savings - expenses - purchases )
        
        return finalRemainder
    } // End of Calculate remainder amount
    
    func sortChronologically() {
        purchasesData.sort {
            $0.purchaseDate! > $1.purchaseDate!
        }
    } // End of sort purchases chronologically
    
    func delayedUpdate() {
        // This is in case the app is being launced for hte firs time, or if there is some new information, it will come in at this time
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            self.fetchPurchases()
            self.fetchBudget()
        }
    } // End of Delayed update
    
    // MARK: - Actions
    // Filter by time button
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
    } // End of Segment did change
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toExpenseDetailVC" {
            guard let destinationVC = segue.destination as? PurchaseDetailViewController,
                  let indexPath = tableView.indexPathForSelectedRow else { return }
            
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
            
            fetchPurchases()
        }
    } // End of Delete
    
} // End of Extension
