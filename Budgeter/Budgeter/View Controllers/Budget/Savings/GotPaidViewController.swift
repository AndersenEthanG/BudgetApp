//
//  GotPaidViewController.swift
//  Budgeter
//
//  Created by Ethan Andersen on 9/9/21.
//

import UIKit

class GotPaidViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var amountPaidBtn: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Properties
    var savings: [Saving] = []
    var amountPaid: Double = 0
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        updateView()
    } // End of View did load
    
    
    // MARK: - Functions
    func updateView() {
        
        tableView.reloadData()
    } // End of Update view
    
    
    // MARK: - Actions
    @IBAction func calculateBtn(_ sender: Any) {
        guard let amount = amountPaidBtn.text else { return }
        
        amountPaid = amount.formatToDouble()
        
        updateView()
    } // End of Calculate Button

} // End of Got Paid View Controller

// MARK: - Extensions
extension GotPaidViewController: UITableViewDelegate, UITableViewDataSource {
    // Number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savings.count
    } // End of Number of Rows
    
    // Cell for row at
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gotPaidCell", for: indexPath) as! GotPaidTableViewCell
        let saving = savings[indexPath.row]
        
        if amountPaid != 0 {
            cell.amountToPay = amountPaid
        }
        
        cell.saving = saving
        
        return cell
    } // End of Cell for row at
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
} // End of Extension
