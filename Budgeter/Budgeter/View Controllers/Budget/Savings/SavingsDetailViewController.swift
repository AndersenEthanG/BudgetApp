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
    @IBOutlet weak var percentSegmenetedController: UISegmentedControl!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var perLabel: UILabel!
    @IBOutlet weak var segmentedController: UISegmentedControl!
    
    
    // MARK: - Properties
    var saving: Saving?
    var isPercent: Bool = false
    var frequency: FilterBy = .month
    
    
    // MARK: - lifecylce
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(SavingsDetailViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        updateView()
    } // End of View did load
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if amountField.text != "" {
            if isPercent == true {
                amountField.text = amountField.text?.formatToDouble().formatToPercent()
            } else {
                amountField.text = amountField.text?.formatToDouble().formatDoubleToMoneyString()
            }
        }
    } // End of keyboard will hide
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    } // End of Function
    
    // MARK: - Functions
    func updateView() {
        if let saving = saving {
            navigationItem.title = "Edit Saving"
            savingNameField.text = saving.name
            amountField.text = saving.amount.formatDoubleToMoneyString()
            isPercent = saving.isPercent
            frequency = (saving.frequency?.formatToFilterBy())!
        } // End of edit or new check
        
        updateIsPercentLabel()
        updateFrequencyLabel()
    } // End of Update View
    
    func updateIsPercentLabel() {
        if isPercent == true {
            perLabel.isHidden = true
            segmentedController.isHidden = true
            
            percentSegmenetedController.selectedSegmentIndex = 0
            
            togglePercentOrFixed()
        } else {
            perLabel.isHidden = false
            segmentedController.isHidden = false
            
            percentSegmenetedController.selectedSegmentIndex = 1
            
            togglePercentOrFixed()
        } // End of If else Is percent
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
    
    func togglePercentOrFixed() {
        if isPercent == true {
            // Make things percent happy
            amountField.text = saving?.amount.formatToPercent()
        } else if isPercent == false {
            // Make things $$$ happy
            amountField.text = saving?.amount.formatDoubleToMoneyString()
        }
    } // End of Toggle percent or Fixed
    
    
    // MARK: - Actions
    @IBAction func saveBtn(_ sender: Any) {
        let isPercent = isPercent
        var amount: Double = amountField.text?.formatToDouble() ?? 0
        let frequency: String = frequency.formatToString()
        let name = savingNameField.text ?? "New Saving"
        
        // New or Update
        if let saving = saving {
            // Delete old one
            SavingController.sharedInstance.deleteSaving(savingToDelete: self.saving!)
            
            // Update this one
            self.saving = Saving(amount: amount, frequency: frequency, isPercent: isPercent, name: name)
            SavingController.sharedInstance.updateSaving()
        } else {
            // Make a new one
            let newSaving = Saving(amount: amount, frequency: frequency, isPercent: isPercent, name: name)
            SavingController.sharedInstance.createSaving(newSaving: newSaving)
        } // End of New or update
        
        navigationController?.popViewController(animated: true)
    } // End of Save Button
    
    @IBAction func percentOrFixedSegmentDidChange(_ sender: Any) {
        switch percentSegmenetedController.selectedSegmentIndex {
        case 0:
            // Percent
            self.isPercent = true
        case 1:
            // Fixed
            self.isPercent = false
        default:
            print("Is line \(#line) working?")
        }
        
        updateIsPercentLabel()
    } // End of action
    
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
