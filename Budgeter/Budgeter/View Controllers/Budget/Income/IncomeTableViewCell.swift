//
//  IncomeTableViewCell.swift
//  Budgeter
//
//  Created by Ethan Andersen on 9/14/21.
//

import UIKit

class IncomeTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var incomeNameLabel: UILabel!
    @IBOutlet weak var incomeAmountLabel: UILabel!
    
    
    // MARK: - Properties
    var income: Income? {
        didSet {
            updateView()
        }
    } // End of Income property
    
    
    // MARK: - Functions
    func updateView() {
        updateIncomeName()
        updateAmount()
    } // End of Update View
    
    func updateIncomeName() {
        guard let income = self.income else { return }
        
        let finalText = income.name
        
        incomeNameLabel.text = finalText
    } // End of Update income name
    
    func updateAmount() {
        guard let income = self.income else { return }
        
        let finalText = ( income.amount.formatDoubleToMoneyString() + " per " + income.frequency! )
        
        incomeAmountLabel.text = finalText
    } // End of Update amount
    
} // End of Income cell
