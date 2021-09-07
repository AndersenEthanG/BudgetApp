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
        amountLabel.text = purchase.amount.formatDoubleToMoney()
    } // End of Update View

} // End of Class
