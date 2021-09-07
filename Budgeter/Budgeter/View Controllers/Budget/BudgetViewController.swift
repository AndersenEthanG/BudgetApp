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
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        budgetTable.delegate = self
        budgetTable.dataSource = self
        
        fetchPurchases()
    } // End of View did load

    
    // MARK: - Functions
    func fetchPurchases() {
        PurchaseController.sharedInstance.fetchPurchases { fetchedPurchases in
            self.purchases = []
            self.purchases = fetchedPurchases
            
            self.updateView()
        }
    } // End of Fetch Purchases
    
    func updateView() {
        budgetTable.reloadData()
    } // End of Update View
    
    
    // MARK: - Actions
    @IBAction func purchaseFilterSwitch(_ sender: Any) {
        
    } // End of Reminder time slider
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toExpenseDetailVC" {
            guard let destinationVC = segue.destination as? PurchaseDetailViewController,
                  let indexPath = budgetTable.indexPathForSelectedRow else { return }
            
            let purchase = purchases[indexPath.row]
            destinationVC.purchase = purchase
        }
    } // End of Segue
    
} // End of Class


// MARK: - Extensions
extension BudgetViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Number of cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return purchases.count
    } // End of Number of cells
    
    // Cell data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "purchaseCell", for: indexPath) as? BudgetTableViewCell
        let purchase = purchases[indexPath.row]
        
        cell?.purchase = purchase
        
        return cell ?? BudgetTableViewCell()
    } // End of Cell Data
    
    // Delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    } // End of Delete
    
} // End of Extension
