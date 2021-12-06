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
        var newTextColor: String = ""
        
        if purchaseAmmount < 0 {
            newTextColor = CustomColors.green
        } else if purchaseAmmount == 0 {
            newTextColor = "000000"
        } else if purchaseAmmount > 0 {
            newTextColor = CustomColors.red
        }
        
        amountLabel.textColor = hexStringToUIColor(hex: newTextColor)
        amountLabel.text = (purchaseAmmount * -1).formatDoubleToMoneyString()
    } // End of Update amount label
    
} // End of Class
