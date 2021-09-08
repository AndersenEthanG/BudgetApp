//
//  IncomeDetailViewController.swift
//  Budgeter
//
//  Created by Ethan Andersen on 9/3/21.
//

import UIKit

class IncomeDetailViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var incomeNameField: UITextField!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var perSegmentedController: UISegmentedControl!
    
    
    // MARK: - Properties
    var income: Income?
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        updateView()
    } // End of View did load
    
    
    // MARK: - Functions
    func updateView() {
        if let income = income {
            navigationItem.title = "Edit Income"
            incomeNameField.text = income.name
            amountField.text = income.amount.formatDoubleToMoney()
            perSegmentedController.selectedSegmentIndex = Int(income.frequency)
        }
    } // End of Update view
    
    
    // MARK: - Actions
    @IBAction func saveBtn(_ sender: Any) {
        // Get values
        let amount: Double = (amountField.text?.formatToDouble())!
        let frequency = 0
        let name = incomeNameField.text ?? "New Income"
        let updatedDate = Date()
        
        // Edit or save
        if let income = income {
            // Delete old one
            IncomeController.sharedInstance.deleteIncome(incomeToDelete: self.income!)

            // Update
            self.income = Income(amount: amount, frequency: frequency, name: name, updatedDate: updatedDate)
            IncomeController.sharedInstance.updateIncome()
        } else {
            // New
            let newIncome = Income(amount: amount, frequency: frequency, name: name, updatedDate: updatedDate)
            IncomeController.sharedInstance.createIncome(newIncome: newIncome)
        }
        
        navigationController?.popViewController(animated: true)
    } // End of Save button
    
    @IBAction func segmentDidChange(_ sender: Any) {
        
    } // End of Segment did change
    
} // End of Class
