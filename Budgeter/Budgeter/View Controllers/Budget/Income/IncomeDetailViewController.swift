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
    var currentSegmentFilterBy: FilterBy = .month
    
    
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
            amountField.text = income.amount.formatDoubleToMoneyString()
            updateSegmentedController()
        }
    } // End of Update view
    
    func updateSegmentedController() {
        guard let income = income else { return }
        
        currentSegmentFilterBy = (income.frequency?.formatToFilterBy())!
        
        var selectedIndex: Int = 0
        
        switch currentSegmentFilterBy {
        case .sorted:
            print("Is line \(#line) working?")
        case .hour:
            selectedIndex = 0
        case .day:
            print("Is line \(#line) working?")
        case .week:
            selectedIndex = 1
        case .month:
            selectedIndex = 2
        case .year:
            selectedIndex = 3
        } // End of Switch
        
        perSegmentedController.selectedSegmentIndex = selectedIndex
    } // End of Update segmented controller
    
    // MARK: - Actions
    @IBAction func saveBtn(_ sender: Any) {
        // Get values
        let amount: Double = (amountField.text?.formatToDouble())!
        let frequency = currentSegmentFilterBy.formatToString()
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
        var selected: FilterBy = currentSegmentFilterBy
        
        switch perSegmentedController.selectedSegmentIndex {
        case 0:
            // Hour
            selected = .hour
        case 1:
            // Week
            selected = .week
        case 2:
            // Month
            selected = .month
        case 3:
            // Year
            selected = .year
        default:
            print("Is line \(#line) working?")
        } // End of Switch
        
        currentSegmentFilterBy = selected
    } // End of Segment did change
    
} // End of Class
