//
//  DebtTableViewCell.swift
//  Budgeter
//
//  Created by Ethan Andersen on 9/7/21.
//

import UIKit

class DebtTableViewCell: UITableViewCell {

    // MARK: - Properties
    @IBOutlet weak var debtNameLabel: UILabel!
    @IBOutlet weak var debtTotalValueLabel: UILabel!
    @IBOutlet weak var debtAmountPaidLabel: UILabel!
    @IBOutlet weak var debtAmountRemainingLabel: UILabel!
    
    
    // MARK: - Properties
    var debt: Debt? {
        didSet {
            updateView()
        }
    } // End of Debt initliaizer
    
    
    func updateView() {
        guard let debt = debt else { return }
        
        debtNameLabel.text = debt.name
        debtTotalValueLabel.text = debt.value.formatDoubleToMoneyString()
        debtAmountPaidLabel.text = debt.amountPaid.formatDoubleToMoneyString()
        debtAmountRemainingLabel.text = (debt.value - debt.amountPaid).formatDoubleToMoneyString()
    } // End of Update View

} // End of Custom Cell
