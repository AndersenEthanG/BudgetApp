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
        
        purchaseAmountLabel.addNumericAccessory(addPlusMinus: true)
        
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
        }
    } // End of Update View

    
    // MARK: - Actions
    @IBAction func saveBtn(_ sender: Any) {
        // Get values
        let amount: Double = purchaseAmountLabel.text!.formatToDouble()
        let name = purchaseNameLabel.text ?? "New Purchase"
        let purchaseDate = purchaseDatePicker.date
        
        if let purchase = purchase {
            // Delete the old one from the array (I'm probably doing this wrong)
            PurchaseController.sharedInstance.deletePurchase(purchaseToDelete: self.purchase!)
            
            // Update
            self.purchase = Purchase(amount: amount, name: name, purchaseDate: purchaseDate)
            PurchaseController.sharedInstance.updatePurchase()
        } else {
            // Create
            let newPurchase = Purchase(amount: amount, name: name, purchaseDate: purchaseDate)
            PurchaseController.sharedInstance.createPurchase(newPurchase: newPurchase)
        }
        
        navigationController?.popViewController(animated: true)
    } // End of Save Button
    
} // End of Class


// MARK: - Custom keyboard thing
// I didn't write this
extension UITextField {
    
    func addNumericAccessory(addPlusMinus: Bool) {
        let numberToolbar = UIToolbar()
        numberToolbar.barStyle = UIBarStyle.default
        
        var accessories : [UIBarButtonItem] = []
        
        if addPlusMinus {
            accessories.append(UIBarButtonItem(title: "+/-", style: UIBarButtonItem.Style.plain, target: self, action: #selector(plusMinusPressed)))
            accessories.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))   //add padding after
        }
        
        accessories.append(UIBarButtonItem(title: "Clear", style: UIBarButtonItem.Style.plain, target: self, action: #selector(numberPadClear)))
        accessories.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))   //add padding space
        accessories.append(UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(numberPadDone)))
        
        numberToolbar.items = accessories
        numberToolbar.sizeToFit()
        
        inputAccessoryView = numberToolbar
    }
    
    @objc func numberPadDone() {
        self.resignFirstResponder()
    }
    
    @objc func numberPadClear() {
        self.text = ""
    }
    
    @objc func plusMinusPressed() {
        guard let currentText = self.text else {
            return
        }
        if currentText.hasPrefix("-") {
            let offsetIndex = currentText.index(currentText.startIndex, offsetBy: 1)
            let substring = currentText[offsetIndex...]  //remove first character
            self.text = String(substring)
        }
        else {
            self.text = "-" + currentText
        }
    }
} // End of Extension
