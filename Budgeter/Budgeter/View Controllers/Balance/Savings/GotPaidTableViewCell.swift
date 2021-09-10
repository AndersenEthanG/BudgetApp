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
    @IBOutlet weak var amountToPayLabel: UILabel!
    
    
    // MARK: - Properties
    var saving: Saving? {
        didSet {
            updateView()
        }
    } // End of Property
    var isDone: Bool = false
    var amountToPay: Double?
    
    
    // MARK: - Functions
    func updateView() {
        guard let saving = saving else { return }
        
        updateAmountToPay()
        
        nameLabel.text = saving.name
        percentAmountLabel.text = saving.amount.formatToPercent()
    } // End of Update view
    
    func updateAmountToPay() {
        // Get amount paid and Percent
        guard let amount = self.amountToPay,
              let percent = saving?.amount else { return }
        
        let finalText: String = (amount * (percent / 100)).formatDoubleToMoneyString()
        
        // Update the value
        amountToPayLabel.text = finalText
    } // End of Update amount to pay
    
    
    // MARK: - Actions
    @IBAction func isDoneToggleBtn(_ sender: Any) {
        isDone.toggle()
        var imageName = ""
        
        switch isDone {
        case true:
            // Make the circle whole
            imageName = "circle.fill"
        case false:
            // Make the circle empty
            imageName = "circle"
        } // End of Switch
        
        doneButton.setImage(UIImage(systemName: imageName), for: .normal)
    } // End of Is done
    
} // End of Cell
