//
//  BudgetTableViewCell.swift
//  Budgeter
//
//  Created by Ethan Andersen on 9/3/21.
//

import UIKit

class BudgetTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    
    // MARK: - Properties
    var purchase: Purchase? {
        didSet {
            updateView()
        }
    } // End of Property
    
    
    // MARK: - Functions
    func updateView() {
        guard let purchase = purchase else { return }
        
        noteLabel.text = purchase.name
        dateLabel.text = purchase.purchaseDate?.formatToString()
        updateAmountLabel()
        
    } // End of Update View
    
    func updateAmountLabel() {
        guard let purchaseAmmount = purchase?.amount else { return }
        
        if purchaseAmmount < 0 {
            amountLabel.text = ( "+" + (purchaseAmmount * -1).formatDoubleToMoneyString() )
            amountLabel.textColor = hexStringToUIColor(hex: CustomColors.green)
        } else {
            amountLabel.text = (purchaseAmmount * -1).formatDoubleToMoneyString()
            amountLabel.textColor = .black
        }
    } // End of Update amount label
    
} // End of Class
