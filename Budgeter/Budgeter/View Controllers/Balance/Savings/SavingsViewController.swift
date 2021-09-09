//
//  SavingsTableViewController.swift
//  Budgeter
//
//  Created by Ethan Andersen on 9/3/21.
//

import UIKit

class SavingsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Properties
    var savings: [Saving] = []
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        fetchSavings()
    } // End of View did load
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchSavings()
    } // End of View will appear
    
    
    // MARK: - Functions
    func fetchSavings() {
        SavingController.sharedInstance.fetchSavings { fetchedSavings in
            self.savings = []
            self.savings = fetchedSavings
            
            self.updateView()
        }
    } // End of Function
    
    func updateView() {
        tableView.reloadData()
    } // End of Update View
    
    
    // MARK: - Actions
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSavingDetailVC" {
            guard let destinationVC = segue.destination as? SavingsDetailViewController,
                  let indexPath = tableView.indexPathForSelectedRow else { return }
            
            let saving = savings[indexPath.row]
            
            destinationVC.saving = saving
        }
    } // End of Segue
    
} // End of Class


// MARK: - Table View Extension
extension SavingsViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - Table view data source
    // Number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savings.count
    } // End of Number of rows
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "incomeCell", for: indexPath)
        let saving = savings[indexPath.row]
        
        cell.textLabel?.text = saving.name
        cell.detailTextLabel?.text = saving.amount.formatDoubleToMoney()
        
        return cell
    } // End of Cell data
    
    // Delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let savingToDelete = savings[indexPath.row]
            
            SavingController.sharedInstance.deleteSaving(savingToDelete: savingToDelete)
            
            fetchSavings()
        }
    } // End of Delete
    
} // End of table view Extension
