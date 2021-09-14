//
//  DebtViewController.swift
//  Budgeter
//
//  Created by Ethan Andersen on 9/7/21.
//

import UIKit

class DebtViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var totalDebtLabel: UILabel!
    @IBOutlet weak var totalDebtValueLabel: UILabel!
    @IBOutlet weak var sortByButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Properties
    var debts: [Debt] = []
    var sortedBy: SortBy = .byValueDescending
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchDebts()
    } // End of View did load

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchDebts()
        tableView.reloadData()
    }
    
    // MARK: - Functions
    func fetchDebts() {
        DebtController.sharedInstance.fetchDebts { fetchedDebts in
            DispatchQueue.main.async {
                self.debts = []
                self.debts = fetchedDebts
                
                self.updateView()
            }
        }
    } // End of Fetch Debt
    
    func updateView() {
        updateTotalDebtLabel()
        updateTotalDebtValueLabel()
        tableView.reloadData()
    } // End of Update View
    
    func updateTotalDebtLabel() {
        var total: Double = 0
        for debt in debts {
            total += (debt.value - debt.amountPaid)
        }
        if total > 0 {
            totalDebtLabel.text = (total.formatDoubleToMoneyString())
        } else {
            totalDebtLabel.text = "$0"
        }
    } // End of Function
    
    func updateTotalDebtValueLabel() {
        var total: Double = 0
        
        for debt in debts {
            total += debt.value
        }
        
        let finalText = total.formatDoubleToMoneyString()
        
        totalDebtValueLabel.text = finalText
    } // End of Function
    
    
    @IBAction func sortByBtn(_ sender: Any) {
        
    } // End of Sory by
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDebtDetailVC" {
            guard let destinationVC = segue.destination as? DebtDetailViewController,
                  let indexPath = tableView.indexPathForSelectedRow else { return }
            
            let debt = debts[indexPath.row]
            destinationVC.debt = debt
        }
    } // End of Segue
    
} // End of Debt View Controller


// MARK: - Extensions
extension DebtViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Number of Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return debts.count
    } // End of Number of rows
    
    // Cell content
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "debtCell", for: indexPath) as? DebtTableViewCell else { return DebtTableViewCell() }
        let debt = self.debts[indexPath.row ]
        
        cell.debt = debt
        
        return cell
    } // End of Cell content
    
    // Delete row
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let debtToDelete: Debt = debts[indexPath.row]
            
            DebtController.sharedInstance.deleteDebt(debtToDeleteUUID: debtToDelete.uuid!)
            
            fetchDebts()
            tableView.reloadData()
        }
    } // End of Delete row
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
} // End of Table View Extension
