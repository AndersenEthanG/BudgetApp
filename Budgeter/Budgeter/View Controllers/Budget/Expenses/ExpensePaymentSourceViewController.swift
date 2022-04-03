//
//  ExpensePaymentSourceViewController.swift
//  Budgeter
//
//  Created by Ethan Andersen on 3/28/22.
//

import UIKit

// MARK: - Protocol
protocol PaymentSourceSelectedProtocol {
    func updatePaymentSource(paymentSource: String)
} // End of Protocol


// MARK: - View Controller
class ExpensePaymentSourceViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Properties
    var paymentSources: [String] = []
    static var updatePaymentSourceDelegate: PaymentSourceSelectedProtocol?
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        tableView.layer.cornerRadius = 10
        
        tableView.reloadData()
    } // End of View did load
    
    
    // MARK: - Actions
    @IBAction func addNewSourceButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "New Payment Source", message: "What would you like to call your new payment source?", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Name..."
            textField.autocapitalizationType = .words
            textField.autocorrectionType = .default
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { action in
            guard let newSourceName = alert.textFields![0].text else { return }
            
            ExpensePaymentSourceViewController.updatePaymentSourceDelegate?.updatePaymentSource(paymentSource: newSourceName)
            
            self.dismiss(animated: true)
        } // End of Save action
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    } // End of New source button tapped
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    } // End of back button
    
} // End of View Controller


// MARK: - Table View Extensions
extension ExpensePaymentSourceViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.paymentSources.count
    } // End of Cell count
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let paymentSources = self.paymentSources
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentSourceCell", for: indexPath)
        
        cell.textLabel?.text = paymentSources[indexPath.row]
        
        // Making the None a little bold
        if indexPath.row == 0 {
            cell.textLabel?.textColor = .red
        }
        
        return cell
    } // End of Cell content
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sourceName = paymentSources[indexPath.row]
        
        let alert = UIAlertController(title: "Payment Source Selected", message: "You can edit the name of this payment source here...", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.text = sourceName
            textField.autocapitalizationType = .words
            textField.autocorrectionType = .default
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { action in
            guard let newSourceName = alert.textFields![0].text else { return }
            
            ExpensePaymentSourceViewController.updatePaymentSourceDelegate?.updatePaymentSource(paymentSource: newSourceName)
            ExpenseController.sharedInstance.editPaymentSourceForAllExpenses(oldPaymentSourceName: sourceName, newPaymentSourceName: newSourceName)
            
            self.dismiss(animated: true)
        } // End of Save action
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    } // End of Did select row
    
} // End of Tableview extension
