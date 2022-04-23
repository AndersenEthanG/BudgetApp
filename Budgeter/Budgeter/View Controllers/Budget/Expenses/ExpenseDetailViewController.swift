//
//  ExpensesDetailViewController.swift
//  Budgeter
//
//  Created by Ethan Andersen on 9/3/21.
//

import UIKit

class ExpenseDetailViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: - Outlets
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var segmentedController: UISegmentedControl!
    @IBOutlet weak var dayPickerView: UIPickerView!
    @IBOutlet weak var paymentSourceButton: UIButton!
    
    
    // MARK: - Properties
    var expense: Expense?
    var frequency: FilterBy = .month
    let pickerDays: [String] = ["none","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28"]
    var paymentDaySelected: String = ""
    let paymentSourceTitle: String = "Payment Source: "
    var paymentSourceName: String = ""
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dayPickerView.delegate = self
        dayPickerView.dataSource = self
        
        ExpensePaymentSourceViewController.updatePaymentSourceDelegate = self
        
        updateView()
    } // End of View did load
    
    // This function makes the keyboard go away
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    } // End of Function
    
    // MARK: - Functions
    func updateView() {
        if let expense = self.expense {
            navigationItem.title = "Edit Expense"
            
            if paymentSourceName == "" {
                paymentSourceName = expense.paymentSource ?? ""
            }
                
            nameField.text = expense.name
            amountField.text = expense.amount.formatDoubleToMoneyString()
            paymentSourceButton.setTitle((self.paymentSourceTitle + paymentSourceName), for: .normal)
            dayPickerView.selectRow((expense.paymentDate?.turnPaymentDateToInt()) ?? 0, inComponent: 0, animated: false)
            frequency = (expense.frequency?.formatToFilterBy())!
            updateSegmentedController()
        } else {
            nameField.becomeFirstResponder()
        }
    } // End of Update view
    
    func updateSegmentedController() {
        var result: Int = 0
        
        switch frequency {
        case .sorted:
            print("Is line \(#line) working?")
        case .hour:
            print("Is line \(#line) working?")
        case .day:
            print("Is line \(#line) working?")
        case .week:
            result = 0
        case .month:
            result = 1
        case .year:
            result = 2
        } // End of Switch
        
        segmentedController.selectedSegmentIndex = result
    } // End of Update segmented controller
    
    
    // MARK: - Actions
    @IBAction func saveBtn(_ sender: Any) {
        // Get values
        let amount: Double = (amountField.text?.formatToDouble())!
        let paymentSource: String = paymentSourceName
        let frequency: String = frequency.formatToString()
        let name = nameField.text ?? "New Expense"
        let paymentDate = paymentDaySelected
        let updateDate = Date()
        
        if let expense = self.expense {
            // Update
            self.expense = Expense(amount: amount, paymentSource: paymentSource, frequency: frequency, name: name, paymentDate: paymentDate, updateDate: updateDate)
            
            // Delete
            ExpenseController.sharedInstance.deleteExpense(expenseToDelete: expense)
        } else {
            // Save
            let newExpense = Expense(amount: amount, paymentSource: paymentSource, frequency: frequency, name: name, paymentDate: paymentDate, updateDate: updateDate)
            ExpenseController.sharedInstance.createExpense(newExpense: newExpense)
        }
        
        navigationController?.popViewController(animated: true)
    } // End of Save button
    
    
    @IBAction func segmentDidChange(_ sender: Any) {
        self.view.endEditing(true)
        
        var newFrequency: FilterBy = .week
        
        switch segmentedController.selectedSegmentIndex {
        case 0:
            // Week
            newFrequency = .week
        case 1:
            // Month
            newFrequency = .month
        case 2:
            // Year
            newFrequency = .year
        default:
            print("Is line \(#line) working?")
        }
        
        frequency = newFrequency
    } // End of Segment did change
    
    // MARK: - Date Picker View
    // Column Count
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Amount of items
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDays.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDays[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.view.endEditing(true)
        self.paymentDaySelected = pickerDays[row]
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPaymentSourceVC" {
            guard let destinationVC = segue.destination as? ExpensePaymentSourceViewController else { return }
            
            getAllPaymentSourceStrings { fetchedPaymentSources in
                destinationVC.paymentSources = fetchedPaymentSources
                
                self.paymentSourceButton.isSelected = false
            }
        }
    } // End of Segue to Payment Source
    
} // End of Expense Detail View controller


// MARK: - Payment source selected protocol
extension ExpenseDetailViewController: PaymentSourceSelectedProtocol {
    func updatePaymentSource(paymentSource: String) {
        if paymentSource == "None" {
            self.paymentSourceName = ""
        } else {
            self.paymentSourceName = paymentSource
        }
        
        self.paymentSourceButton.setTitle("Payment Source: \(self.paymentSourceName)", for: .normal)
    } // End of update payment source
} // End of payment source selected protocol
