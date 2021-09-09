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


/// This extension turns money attributes from doubles into happy strings that look like money
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

/// This is similar to the SortBy, but it is for dates
enum FilterBy {
    case sorted, hour, day, week, month, year
} // End of Filter by

func sortPurchasesByTimeArray(arrayToFilter: [Purchase], filterBy: FilterBy) -> [Purchase] {
    var finalArray: [Purchase] = []
    let today = Date()
    
    if filterBy == .sorted {
        finalArray = arrayToFilter.sorted {
            $0.purchaseDate?.compare($1.purchaseDate!) == .orderedDescending
        }
    } else {
        for item in arrayToFilter {
            let isSameDayResult = isSameDay(date1: today, date2: item.purchaseDate!, filterBy: filterBy)
            if isSameDayResult == true {
                finalArray.append(item)
            }
        } // End of Loop
    } // End of Else Statement
    
    return finalArray
} // End of Filter By Function


/// This is used for our sorting things, it checks if dates are in the same time
func isSameDay(date1: Date, date2: Date, filterBy: FilterBy) -> Bool {
    var isSameDay: Bool?
    
    switch filterBy {
    case .sorted:
        print("Is line \(#line) working?")
    case .hour:
        print("Is line \(#line) working?")
    case .day:
        let diff = Calendar.current.dateComponents([.day], from: date1, to: date2)
        if diff.day == 0 {
            isSameDay = true
        } else {
            isSameDay = false
        }
    case .week:
        let diff = Calendar.current.dateComponents([.weekOfMonth], from: date1, to: date2)
        if diff.weekOfMonth == 0 {
            isSameDay = true
        } else {
            isSameDay = false
        }
    case .month:
        let diff = Calendar.current.dateComponents([.month], from: date1, to: date2)
        if diff.month == 0 {
            isSameDay = true
        } else {
            isSameDay = false
        }
    case .year:
        let diff = Calendar.current.dateComponents([.year], from: date1, to: date2)
        if diff.year == 0 {
            isSameDay = true
        } else {
            isSameDay = false
        }
    } // End of Switch

    return isSameDay!
} // End of Is same day


/// Used to format Dates into pretty strings
extension Date {
    func formatToString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
} // End of Extension


/// In an effort to save time and energy, I'm saving all incomes and such as hourly rates
extension Double {
    func convertToHourlyRate(currentRate: FilterBy) -> Double {
        var returnValue: Double = 0
        
        switch currentRate {
        case .sorted:
            print("Is line \(#line) working?")
        case .day:
            print("Is line \(#line) working?")
        case .hour:
            returnValue = self
        case .week:
            returnValue = (self / 40)
        case .month:
            returnValue = (self / 27.74)
        case .year:
            returnValue = (self / 52 / 5)
        } // End of Switch
        
        return returnValue
    }
} // End of convert to hourly rate


// This will turn hourly back into the regular rate
func convertHourlyToOtherRate(hourlyRate: Double, desiredRate: FilterBy) -> Double {
    var finalValue: Double = hourlyRate
    
    switch desiredRate {
    case .sorted:
        print("Is line \(#line) working?")
    case .hour:
        finalValue = (finalValue * 1)
    case .day:
        finalValue = (finalValue * 8)
    case .week:
        finalValue = (finalValue * 40)
    case .month:
        finalValue = (finalValue * 40 * 52 / 12)
    case .year:
        finalValue = (finalValue * 40 * 52)
    } // End of Switch
    
    return finalValue
} // End of Function



