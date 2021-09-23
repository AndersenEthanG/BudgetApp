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
    var calculateWasPressed: Bool = false
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        updateView()
    } // End of View did load
    
    // This function makes the keyboard go away
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    } // End of Function
    
    
    // MARK: - Functions
    func updateView() {
        updateAmountPaidLabel()
        tableView.reloadData()
    } // End of Update view
    
    func updateAmountPaidLabel() {
        if amountPaidBtn.text != "" {
            amountPaidBtn.text = amountPaid.formatDoubleToMoneyString()
        }
    } // End of Update Amount Paid Label
    
    // MARK: - Actions
    @IBAction func calculateBtn(_ sender: Any) {
        guard let amount = amountPaidBtn.text else { return }
        
        calculateWasPressed = true
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
        
        if calculateWasPressed == true {
            cell.rightStack.isHidden = false
        } else {
            cell.rightStack.isHidden = true
        }
        
        if amountPaid != 0 {
            cell.amountToPay = amountPaid
        }
        
        cell.saving = saving
        
        return cell
    } // End of Cell for row at
    
} // End of Extension
