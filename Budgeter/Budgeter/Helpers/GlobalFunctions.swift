//
//  GlobalFunctions.swift
//  Budgeter
//
//  Created by Ethan Andersen on 9/3/21.
//

import UIKit

/// This function is used to navigate from view controller to view controller, I just made the code a little smaller to save space
func vcGrabber(vcName: String) -> UIViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = storyboard.instantiateViewController(identifier: vcName)
    
    return vc
} // End of vc Grabber



/// This extension removes decimals for easy reading
extension Double {
    func formatDoubleToMoney() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        let formattedNumber = numberFormatter.string(from: NSNumber(value: self))
        
        return formattedNumber!
    }
} // End of format double to money string


/// This turns a money style string into a usable double
extension String {
    func formatToDouble() -> Double {
        let input = String(self)
        
        if input == "" {
            return 0
        } else {
            
        var trimmedInput = input.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789.").inverted)
        trimmedInput = trimmedInput.replacingOccurrences(of: "$", with: "")
        trimmedInput = trimmedInput.replacingOccurrences(of: ",", with: "")
        let doubleTrimmedInput = Double(trimmedInput)
        
        return doubleTrimmedInput!
        }
    }
} // End of Format to double


/// This is for the sorting systems
enum SortBy {
    case byValueAscending, byValueDescending, alphabetically
} // End of Sort By
