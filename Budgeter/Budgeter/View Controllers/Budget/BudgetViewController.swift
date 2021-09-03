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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    } // End of View did load

    
    // MARK: - Actions
    @IBAction func remainderTimeSlider(_ sender: Any) {
        
    } // End of Reminder time slider
    
    @IBAction func newExpenseBtn(_ sender: Any) {
        
    } // End of New purchase
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toExpenseDetailVC" {
            
        }
    } // End of Segue
    
} // End of Class


// MARK: - Extensions
extension BudgetViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Number of cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    } // End of Number of cells
    
    // Cell data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    } // End of Cell Data
    
    // Delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    } // End of Delete
    
} // End of Extension
