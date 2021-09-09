//
//  SavingsDetailViewController.swift
//  Budgeter
//
//  Created by Ethan Andersen on 9/3/21.
//

import UIKit

class SavingsDetailViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var savingNameField: UITextField!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var percentOrFixedLabel: UILabel!
    @IBOutlet weak var segmentedController: UISegmentedControl!
    @IBOutlet weak var percentOrFixedSwitch: UISwitch!
    
    
    // MARK: - Properties
    var saving: Saving?
    var isPercent: Bool = true
    var frequency: FilterBy = .week
    
    
    // MARK: - lifecylce
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView()
    } // End of View did load

    
    // MARK: - Functions
    func updateView() {
        if let saving = saving {
            navigationItem.title = "Edit Saving"
            savingNameField.text = saving.name
            amountField.text = saving.amount.formatDoubleToMoney()
            isPercent = saving.isPercent
            frequency = .day
        } // End of if we are editing
        
        updateIsPercentLabel()
        updateFrequencyLabel()
    } // End of Update View
    
    func updateIsPercentLabel() {
        var finalText = ""
        
        if isPercent == true {
             finalText = "Percent"
        } else {
            finalText = "Fixed"
        }
        
        percentOrFixedLabel.text = finalText
    } // End of Update percent label
    
    
    func updateFrequencyLabel() {
        var segmentIndex = 0
        
        switch self.frequency {
        
        case .sorted:
            print("Is line \(#line) working?")
        case .hour:
            print("Is line \(#line) working?")
        case .day:
            print("Is line \(#line) working?")
        case .week:
            segmentIndex = 0
        case .month:
            segmentIndex = 1
        case .year:
            segmentIndex = 2
        }
    
        segmentedController.selectedSegmentIndex = segmentIndex
    } // End of Update frequency label
    
    // MARK: - Actions
    @IBAction func saveBtn(_ sender: Any) {
        let amount: Double = amountField.text?.formatToDouble() ?? 0
        let frequency = ""
        let isPercent = isPercent
        let name = savingNameField.text ?? "New Saving"
        
        let newSaving = Saving(amount: amount, frequency: frequency, isPercent: isPercent, name: name)
        SavingController.sharedInstance.createSaving(newSaving: newSaving)
        
        navigationController?.popViewController(animated: true)
    } // End of Save Button
    
    @IBAction func percentOrFixedSwitchTap(_ sender: Any) {
        isPercent.toggle()
        
        updateIsPercentLabel()
    } // End of Percent or fixed switch tapped
    
    @IBAction func segmentDidChange(_ sender: Any) {
        switch segmentedController.selectedSegmentIndex {
        case 0:
            // Week
            frequency = .week
        case 1:
            // Month
            frequency = .month
        case 2:
            // Year
            frequency = .year
        default:
            print("Is line \(#line) working?")
        } // End of Switch
    } // End of Segment did Change
    
    
} // End of Class
