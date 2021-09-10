//
//  GotPaidTableViewCell.swift
//  Budgeter
//
//  Created by Ethan Andersen on 9/9/21.
//

import UIKit

class GotPaidTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var percentAmountLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    
    // MARK: - Properties
    var saving: Saving? {
        didSet {
            updateView()
        }
    } // End of Property
    var isDone: Bool = false
    
    
    // MARK: - Functions
    func updateView() {
        guard let saving = saving else { return }
        
        nameLabel.text = saving.name
        percentAmountLabel.text = saving.amount.formatDoubleToMoneyString()
    } // End of Update view
    
    
    // MARK: - Actions
    @IBAction func isDoneToggleBtn(_ sender: Any) {
        
    } // End of Is done
    
} // End of Cell
