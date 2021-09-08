//
//  IncomeDetailViewController.swift
//  Budgeter
//
//  Created by Ethan Andersen on 9/3/21.
//

import UIKit

class IncomeDetailViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var newIncomeLabel: UILabel!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var perSegmentedController: UISegmentedControl!
    @IBOutlet weak var taxPercentField: UITextField!
    
    
    // MARK: - Properties
    var income: Income?
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        updateView()
    } // End of View did load
    
    
    // MARK: - Functions
    func updateView() {
        
    } // End of Update view
    
    
    // MARK: - Actions
    @IBAction func saveBtn(_ sender: Any) {
        // Edit or save
        if let income = income {
            // Update
            // Get values
            let amount: Double = 0
            let frequency = 0
            let name = ""
            let taxPercent: Decimal = 0
            let updatedDate = Date()
            
            // Save
            self.income = Income(amount: amount, frequency: frequency, name: name, taxPercent: taxPercent, updatedDate: updatedDate)
            IncomeController.sharedInstance.updateIncome()
            
        } else {
            // New
            let amount: Double = 0
            let frequency = 0
            let name = ""
            let taxPercent: Decimal = 0
            let updatedDate = Date()
            
            // Save
            let newIncome = Income(amount: amount, frequency: frequency, name: name, taxPercent: taxPercent, updatedDate: updatedDate)
            IncomeController.sharedInstance.createIncome(newIncome: newIncome)
        }
        
        
    } // End of Save button
    
    @IBAction func segmentDidChange(_ sender: Any) {
        
    } // End of Segment did change
    
} // End of Class
