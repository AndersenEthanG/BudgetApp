//
//  IncomeTableViewController.swift
//  Budgeter
//
//  Created by Ethan Andersen on 9/3/21.
//

import UIKit

class IncomeViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Properties
    var incomes: [Income] = []
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchIncome()
    } // End of View did load
    
    
    // MARK: - Functions
    func fetchIncome() {
        IncomeController.sharedInstance.fetchIncomes { fetchedIncomes in
            DispatchQueue.main.async {
                self.incomes = []
                self.incomes = fetchedIncomes
                
                self.updateView()
            }
        }
    } // End of Fetch income
    
    
    func updateView() {
        
        tableView.reloadData()
    } // End of Update View
    
    
    // MARK: - Actions
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toIncomeDetailVC" {
            guard let destinationVC = segue.destination as? IncomeDetailViewController,
                  let indexPath = tableView.indexPathForSelectedRow else { return }
            
            let income = incomes[indexPath.row]
            
            destinationVC.income = income
        }
    } // End of Segue
    
} // End of Class


// MARK: - Extensions
extension IncomeViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - Table view data source
    // Number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return incomes.count
    } // End of Number of rows
    
    // Cell Data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "incomeCell", for: indexPath)
        
        let income = incomes[indexPath.row]
        
        cell.textLabel?.text = income.name
        
        return cell
    } // End of Cell data
    
    // Delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
} // End of Table View Extension
