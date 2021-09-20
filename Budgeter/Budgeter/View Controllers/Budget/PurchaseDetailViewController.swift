//
//  NewExpenseViewController.swift
//  Budgeter
//
//  Created by Ethan Andersen on 9/3/21.
//

import UIKit

class PurchaseDetailViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var purchaseNameLabel: UITextField!
    @IBOutlet weak var purchaseAmountLabel: UITextField!
    @IBOutlet weak var purchaseDatePicker: UIDatePicker!
    
    
    // MARK: - Properties
    var purchase: Purchase?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView()
    } // End of View did load

    // This function makes the keyboard go away
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    } // End of Function
    
    // MARK: - Functions
    func updateView() {
        if let purchase = purchase {
            navigationItem.title = "Edit Purchase"
            purchaseNameLabel.text = purchase.name
            purchaseAmountLabel.text = purchase.amount.formatDoubleToMoneyString()
            purchaseDatePicker.date = purchase.purchaseDate!
        } // End of If Purchase exists
        
        
    } // End of Update View
    
    
    // MARK: - Actions
    @IBAction func saveBtn(_ sender: Any) {
        // Get values
        let amount = purchaseAmountLabel.text
        let name = purchaseNameLabel.text ?? "New Purchase"
        let purchaseDate = purchaseDatePicker.date
        
        if let purchase = purchase {
            // Delete the old one from the array (I'm probably doing this wrong)
            PurchaseController.sharedInstance.deletePurchase(purchaseToDelete: self.purchase!)
            
            // Update
            self.purchase = Purchase(amount: (amount?.formatToDouble())!, name: name, purchaseDate: purchaseDate)
            PurchaseController.sharedInstance.updatePurchase()
        } else {
            // Create
            let newPurchase = Purchase(amount: amount?.formatToDouble() ?? 0, name: name, purchaseDate: purchaseDate)
            PurchaseController.sharedInstance.createPurchase(newPurchase: newPurchase)
        }
        
        navigationController?.popViewController(animated: true)
    } // End of Save Button
    
} // End of Class
