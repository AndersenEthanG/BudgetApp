//
//  DebtDetailViewController.swift
//  Budgeter
//
//  Created by Ethan Andersen on 9/7/21.
//

import UIKit

class DebtDetailViewController: UIViewController {

    // MARK: - Outlets
    // Labels
    @IBOutlet weak var debtNameLabel: UILabel!
    @IBOutlet weak var amountPaidLabel: UILabel!
    @IBOutlet weak var totalValueLabel: UILabel!
    @IBOutlet weak var amountRemainingLabel: UILabel!
    // Text Fields
    @IBOutlet weak var debtNameField: UITextField!
    @IBOutlet weak var amountPaidField: UITextField!
    @IBOutlet weak var totalValueField: UITextField!
    
    
    // MARK: - Properties
    var debt: Debt?
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        updateView()
    } // End of View did load
    
    func updateView() {
        guard let debt = debt else { return }
        
        debtNameField.text = debt.name
        amountPaidField.text = debt.amountPaid.formatDoubleToMoneyString()
        totalValueField.text = debt.value.formatDoubleToMoneyString()
        amountRemainingLabel.text = ( "Amount Remaining: " + (debt.value - debt.amountPaid).formatDoubleToMoneyString())
        
    } // End of Update view
    
    // This function makes the keyboard go away
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    } // End of Function
    
    // MARK: - Actions
    @IBAction func saveBtn(_ sender: Any) {
        // Grab all fields
        let updateDate = Date()
        
        // Save or Update
        if let debt = debt {
            // Delete old one
            DebtController.sharedInstance.deleteDebt(debtToDeleteUUID: self.debt!.uuid!)
            
            // Update
            let amountPaid = (amountPaidField.text?.formatToDouble())!
            
            let name = debtNameField.text ?? debt.name
            let value: Double = totalValueField.text?.formatToDouble() ?? debt.value
            
            // Save data
            self.debt = Debt(amountPaid: amountPaid, name: name!, updateDate: updateDate, value: value)
            DebtController.sharedInstance.updateDebt()
        } else {
            // Create
            let amountPaid: Double = amountPaidField.text?.formatToDouble() ?? 0
            let name = debtNameField.text
            let value: Double = totalValueField.text?.formatToDouble() ?? 0
            
            // Save data
            let newDebt = Debt(amountPaid: amountPaid, name: name ?? "New Debt", updateDate: updateDate, value: value)
            DebtController.sharedInstance.createDebt(newDebt: newDebt)
        } // End of Else if
        
        navigationController?.popViewController(animated: true)
    } // End of Save Btn
    
    
} // End of Debt Detail VC
