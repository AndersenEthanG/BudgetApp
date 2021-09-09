//
//  IncomeTableViewController.swift
//  Budgeter
//
//  Created by Ethan Andersen on 9/3/21.
//

import UIKit

class IncomeViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalIncomeLabel: UILabel!
    @IBOutlet weak var rateSegment: UISegmentedControl!
    
    
    // MARK: - Properties
    var incomes: [Income] = []
    var currentSelectedIndex: FilterBy = .hour
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchIncome()
    } // End of View did load
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchIncome()
    } // End of View will appear
    
    // MARK: - Functions
    func fetchIncome() {
        IncomeController.sharedInstance.fetchIncomes { fetchedIncomes in
            DispatchQueue.main.async {
                self.incomes = []
                self.incomes = fetchedIncomes
                
                self.updateView()
            }
        }
    } // End of Fetch income
    
    
    func updateView() {
        updateTotalIncomeLabel()
        tableView.reloadData()
    } // End of Update View
    
    
    func updateTotalIncomeLabel() {
        var finalPerHourAmount: Double = 0
        
        for income in incomes {
            finalPerHourAmount += income.amountPerHour
        }
        
        let finalAmount = convertHourlyToOtherRate(hourlyRate: finalPerHourAmount, desiredRate: currentSelectedIndex)
        
        totalIncomeLabel.text = finalAmount.formatDoubleToMoney()
    } // End of Update total income label
    
    
    // MARK: - Actions
    @IBAction func segmentDidChange(_ sender: Any) {
        var currentIndex: FilterBy = currentSelectedIndex
        
        switch rateSegment.selectedSegmentIndex {
        case 0:
            // Hour
            currentIndex = .hour
        case 1:
            // Week
            currentIndex = .week
        case 2:
            // Month
            currentIndex = .month
        case 3:
            // Year
            currentIndex = .year
        default:
            print("Is line \(#line) working?")
        } // End of Switch
        
        currentSelectedIndex = currentIndex
        
        updateView()
    } // End of Segment did change
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toIncomeDetailVC" {
            guard let destinationVC = segue.destination as? IncomeDetailViewController,
                  let indexPath = tableView.indexPathForSelectedRow else { return }
            
            let income = incomes[indexPath.row]
            
            destinationVC.income = income
        }
    } // End of Segue
    
} // End of Class


// MARK: - Extensions
extension IncomeViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - Table view data source
    // Number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return incomes.count
    } // End of Number of rows
    
    // Cell Data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "incomeCell", for: indexPath)
        
        let income = incomes[indexPath.row]
        let incomeAmount = convertHourlyToOtherRate(hourlyRate: income.amountPerHour, desiredRate: currentSelectedIndex)
        
        cell.textLabel?.text = income.name
        cell.detailTextLabel?.text = incomeAmount.formatDoubleToMoney()
        
        return cell
    } // End of Cell data
    
    // Delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let incomeToDelete = incomes[indexPath.row]
            
            IncomeController.sharedInstance.deleteIncome(incomeToDelete: incomeToDelete)
            
            fetchIncome()
        }
    } // End of Delete
    
} // End of Table View Extension
