//
//  BudgetViewController.swift
//  Budgeter
//
//  Created by Ethan Andersen on 9/3/21.
//

import UIKit

class BudgetViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var remainderAmountLabel: UILabel!
    @IBOutlet weak var budgetTable: UITableView!
    @IBOutlet weak var purchaseFilterSwitch: UISegmentedControl!
    
    
    // MARK: - Properties
    var purchases: [Purchase] = []
    var purchasesData: [Purchase] = []
    var filteredBy: FilterBy = .sorted
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        purchaseFilterSwitch.selectedSegmentIndex = 2
        
        budgetTable.delegate = self
        budgetTable.dataSource = self
        
        fetchPurchases()
    } // End of View did load

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchPurchases()
    }
    
    // MARK: - Functions
    func fetchPurchases() {
        PurchaseController.sharedInstance.fetchPurchases { fetchedPurchases in
            self.purchases = []
            self.purchases = fetchedPurchases
            
            self.filterData()
            self.updateView()
        }
    } // End of Fetch Purchases
    
    func updateView() {
        
        budgetTable.reloadData()
    } // End of Update View
    
    func filterData() {
        let purchaseArray = self.purchases
        let filterBy = filteredBy
        
        self.purchasesData = sortPurchasesByTimeArray(arrayToFilter: purchaseArray, filterBy: filterBy)
        
        updateView()
    } // End of Filter data
    
    
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
            filteredBy = .sorted
        default:
            print("Is line \(#line) working?")
        }
        
        filterData()
    } // End of Segment did  change

    
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
            
            fetchPurchases()
        }
    } // End of Delete
    
} // End of Extension
