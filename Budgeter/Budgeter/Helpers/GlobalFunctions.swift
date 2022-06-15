//
//  GlobalFunctions.swift
//  Budgeter
//
//  Created by Ethan Andersen on 9/3/21.
//

import UIKit
import Charts

// This is a refresh thing
var UserDidLogInForFirstTime: Bool = false

// This are my custom colors
enum CustomColors {
    static let green: String = "22d16e"
    static let red: String = "FF0000"
} // End of Struct

/// This function is used to navigate from view controller to view controller, I just made the code a little smaller to save space
func vcGrabber(vcName: String) -> UIViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = storyboard.instantiateViewController(identifier: vcName)
    
    return vc
} // End of vc Grabber


/// This extension turns money attributes from doubles into happy strings that look like money
extension Double {
    func formatDoubleToMoneyString() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        let formattedNumber = numberFormatter.string(from: NSNumber(value: self))
        
        return formattedNumber!
    }
    
    func formatToPercent() -> String {
        let properNumber = ( self / 100 )
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        let formattedNumber = numberFormatter.string(from: NSNumber(value: properNumber))
        
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
            
            var trimmedInput = input.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789.-").inverted)
            trimmedInput = trimmedInput.replacingOccurrences(of: "$", with: "")
            trimmedInput = trimmedInput.replacingOccurrences(of: ",", with: "")
            let doubleTrimmedInput = Double(trimmedInput)

            return doubleTrimmedInput ?? 0
        } // End of Primary if else
    } // End of Function
} // End of Format to double extension


/// This is for the sorting systems
enum SortBy {
    case byValueAscending, byValueDescending, alphabetically, byDateAscending, byDateDescending
} // End of Sort By


/// This is similar to the SortBy, but it is for dates
enum FilterBy {
    case sorted, hour, day, week, month, year
} // End of Filter by

/// Some filter by things require saving as a string
extension FilterBy {
    func formatToString() -> String {
        var returnString = ""
        
        switch self {
        case .sorted:
            returnString = "sorted"
        case .hour:
            returnString = "hour"
        case .day:
            returnString = "day"
        case .week:
            returnString = "week"
        case .month:
            returnString = "month"
        case .year:
            returnString = "year"
        }
        
        return returnString
    }
} // End of Format to string from Filter By

/// This turns strings back into FilterBy ways
extension String {
    func formatToFilterBy() -> FilterBy {
        var returnValue: FilterBy = .day
        
        switch self {
        case "sorted":
            returnValue = .day
        case "hour":
            returnValue = .hour
        case "day":
            returnValue = .day
        case "week":
            returnValue = .week
        case "month":
            returnValue = .month
        case "year":
            returnValue = .year
        default:
            print("Is line \(#line) working?")
        }
        
        return returnValue
    }
} // End of format to filter by


func sortPurchasesByTimeArray(arrayToFilter: [Purchase], filterBy: FilterBy) -> [Purchase] {
    var finalArray: [Purchase] = []
    
    if filterBy == .sorted {
        finalArray = arrayToFilter.sorted {
            $0.purchaseDate?.compare($1.purchaseDate!) == .orderedDescending
        }
    } else {
        for item in arrayToFilter {
            let isSameDayResult = isSameDay(dateToCompare: item.purchaseDate!, filterBy: filterBy)
            if isSameDayResult == true {
                finalArray.append(item)
            }
        } // End of Loop
    } // End of Else Statement
    
    return finalArray
} // End of Filter By Function


// This function needed cleanup - it was doing literal 7 days, 1 month, instead of *that* week or *this* month
// This is used for our sorting things, it checks if dates are in the same time
func isSameDay(dateToCompare: Date, filterBy: FilterBy) -> Bool {
    let dateToday = Date()
    var isSameDay: Bool?
    
    switch filterBy {
    case .sorted:
        print("Is line \(#line) working?")
    case .hour:
        print("Is line \(#line) working?")
    case .day:
        switch Calendar.current.isDateInToday(dateToCompare) {
        case true:
            isSameDay = true
        case false:
            isSameDay = false
        }
    case .week:
        switch Calendar.current.isDate(dateToday, equalTo: dateToCompare, toGranularity: .weekOfMonth) {
        case true:
            isSameDay = true
        case false:
            isSameDay = false
        }
    case .month:
        switch Calendar.current.isDate(dateToday, equalTo: dateToCompare, toGranularity: .month) {
        case true:
            isSameDay = true
        case false:
            isSameDay = false
        }
    case .year:
        switch Calendar.current.isDate(dateToday, equalTo: dateToCompare, toGranularity: .year) {
        case true:
            isSameDay = true
        case false:
            isSameDay = false
        }
    } // End of Switch
    
    return isSameDay!
} // End of Is same day


/// Used to format Dates into pretty strings
extension Date {
    func formatToString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }
} // End of Extension


/// In an effort to save time and energy, I'm saving all incomes and such as hourly rates
extension Double {
    func OLDconvertToHourlyRate(currentRate: FilterBy) -> Double {
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
            returnValue = (((self * 12) / 52) / 40)
        case .year:
            returnValue = (self / 52 / 40)
        } // End of Switch
        
        return returnValue
    }
} // End of convert to hourly rate


// This will turn hourly back into the regular rate
func OLDconvertHourlyToOtherRate(hourlyRate: Double, desiredRate: FilterBy) -> Double {
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


// This is used for the Budget model and controller, it will turn the standard monthly rate to the desired rate
func OLDconvertMonthlyRateToOtherRate(monthlyRate: Double, desiredRate: FilterBy) -> Double {
    var finalValue: Double = monthlyRate
    
    switch desiredRate {
    case .sorted:
        print("Is line \(#line) working?")
    case .hour:
        finalValue = ( monthlyRate / 730 )
    case .day:
        finalValue = ( monthlyRate / 30.14 )
    case .week:
        finalValue = ( monthlyRate / 4.34 )
    case .month:
        finalValue = ( monthlyRate * 1 )
    case .year:
        finalValue = ( monthlyRate * 12 )
    } // End of Switch
    
    return finalValue
} // End of

func convertRate(rate: Double, currentRate: FilterBy, desiredRate: FilterBy) -> Double {
    
    let hourlyRate = rate.OLDconvertToHourlyRate(currentRate: currentRate)
    let finalValue = OLDconvertHourlyToOtherRate(hourlyRate: hourlyRate, desiredRate: desiredRate)
    
    return finalValue
} // End of Function

func convertBudget(budget: Budget, currentRate: FilterBy, desiredRate: FilterBy) -> Budget {
    
    let incomeTotal = convertRate(rate: budget.incomeTotal, currentRate: currentRate, desiredRate: desiredRate)
    let savingTotal = convertRate(rate: budget.savingTotal, currentRate: currentRate, desiredRate: desiredRate)
    let reoccuringTotal = convertRate(rate: budget.reoccuringTotal, currentRate: currentRate, desiredRate: desiredRate)
    
    return Budget(incomeTotal: incomeTotal, savingTotal: savingTotal, reoccuringTotal: reoccuringTotal)
} // End of Function


func hexStringToUIColor(hex: String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
} // End of Function


// MARK: - This turns our Payment Date String into an Int
extension String {
    func turnPaymentDateToInt() -> Int {
        switch self {
        case "none" :
            return 0
        case "1":
            return 1
        case "2":
            return 2
        case "3":
            return 3
        case "4":
            return 4
        case "5":
            return 5
        case "6":
            return 6
        case "7":
            return 7
        case "8":
            return 8
        case "9":
            return 9
        case "10":
            return 10
        case "11":
            return 11
        case "12":
            return 12
        case "13":
            return 13
        case "14":
            return 14
        case "15":
            return 15
        case "16":
            return 16
        case "17":
            return 17
        case "18":
            return 18
        case "19":
            return 19
        case "20":
            return 20
        case "21":
            return 21
        case "22":
            return 22
        case "23":
            return 23
        case "24":
            return 24
        case "25":
            return 25
        case "26":
            return 26
        case "27":
            return 27
        case "28":
            return 28
        default:
            return 0
        } // End of case switch
    } // End of Turn payment date to string
} // End of Extension


// MARK: - Payment Source calculator
func getAllPaymentSourceStrings(🐶: @escaping ([String]) -> Void) {
    var allStrings: [String] = []
    
    ExpenseController().fetchExpenses { fetchedExpenses in
        for expense in fetchedExpenses {
            if expense.paymentSource != nil && expense.paymentSource != "" && !allStrings.contains(expense.paymentSource!) {
                allStrings.append(expense.paymentSource!)
            }
        } // End of Loop
        
        allStrings.insert("None", at: 0)
        
        🐶(allStrings)
    } // End of Fetch expenses
} // End of Get all payment strings


// MARK: - Chart Helper Struct
struct UnsortedChartStruct {
    var dayNumber: Double
    var amount: Double
} // End of unsorted chart struct

struct ChartViewHelper {
    func getPurchasesChartData() -> LineChartData {
        var finalLineChartDataEntries = [ChartDataEntry]()
        var purchases: [Purchase] = []
        
        // Get all of the data
        PurchaseController.sharedInstance.fetchPurchases { fetchedPurchases in
            purchases = fetchedPurchases
        } // End of fetch purchases
        
        // Only get this month
        purchases = sortPurchasesByTimeArray(arrayToFilter: purchases, filterBy: .month)
        
        // Sort to days
        var unSortedPurchases: [UnsortedChartStruct] = []
        
        for purchase in purchases {
            
            // Get just the day
            let date = purchase.purchaseDate ?? Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d"
            let dayOfTheWeekString = dateFormatter.string(from: date)

            let dayNumber = Double(dayOfTheWeekString) ?? 0
            let amount = purchase.amount
            
            let newItem = UnsortedChartStruct(dayNumber: dayNumber, amount: amount)
            
            unSortedPurchases.append(newItem)
        } // End of Loop
        
        let sortedPurchases = unSortedPurchases.sorted(by: {
            $0.dayNumber < $1.dayNumber
        })
        
        var countingNumber: Double = 0
        
        for purchase in sortedPurchases {
            
            countingNumber += purchase.amount
            
            finalLineChartDataEntries.append(ChartDataEntry(x: purchase.dayNumber, y: countingNumber))
        }
        
        // Return data
        let chartDataSet = LineChartDataSet(entries: finalLineChartDataEntries)
        
        chartDataSet.drawCirclesEnabled = false
        chartDataSet.lineWidth = 2
        chartDataSet.mode = .horizontalBezier
        chartDataSet.valueTextColor = .black
        chartDataSet.setColor(hexStringToUIColor(hex: CustomColors.green ))
        chartDataSet.label = "Purchases"
        
        return LineChartData(dataSet: chartDataSet)
    } // End of get purchases chart data
    
    
    func getExpensesChartData() -> LineChartData {
        var finalLineChartDataEntries = [ChartDataEntry]()
        var expenses: [Expense] = []
        
        // Get all of the data
        ExpenseController.sharedInstance.fetchExpenses(🐶: { fetchedExpenses in
            expenses = fetchedExpenses
        })

        // Make into an usable object
        var newExpenses: [UnsortedChartStruct] = []
        
        for expense in expenses {
    
            // Decided to make it random if the expense doesn't have a payment date
            if expense.paymentDate == "" {
                let randomDates = ["2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27"]
                expense.paymentDate = randomDates.randomElement()
            } // End of if the expense doesn't have a payment date
            
            let dayNumber: Double = Double(expense.paymentDate ?? "0") ?? 0
            let amount: Double = expense.amount
            
            let newExpense = UnsortedChartStruct(dayNumber: dayNumber, amount: amount)
            
            newExpenses.append(newExpense)
        }
        
        // Sort new expenses by date
        newExpenses = newExpenses.sorted(by: {
            $0.dayNumber < $1.dayNumber
        })
        
        // Make one expense higher after another for graph
        var finalExpenses: [UnsortedChartStruct] = []
        finalExpenses.append(UnsortedChartStruct(dayNumber: 0, amount: 0))
        
        var countingNumber: Double = 0
        
        for expense in newExpenses {
            
            countingNumber += expense.amount
            
            let newAmount = countingNumber
            
            let newElement = UnsortedChartStruct(dayNumber: expense.dayNumber, amount: newAmount)
            finalExpenses.append(newElement)
        }
        
        finalExpenses.append(UnsortedChartStruct(dayNumber: 29, amount: countingNumber + 1))
        
        
        // Put the data into usable chart stuff
        for expense in finalExpenses {
            finalLineChartDataEntries.append(ChartDataEntry(x: expense.dayNumber, y: expense.amount))
        }
        
        // Return the Data
        // Return data
        let chartDataSet = LineChartDataSet(entries: finalLineChartDataEntries)
        
        chartDataSet.drawCirclesEnabled = false
        chartDataSet.lineWidth = 2
        chartDataSet.mode = .horizontalBezier
        chartDataSet.valueTextColor = .black
        chartDataSet.setColor(hexStringToUIColor(hex: CustomColors.red ))
        chartDataSet.label = "Expenses"
        
        return LineChartData(dataSet: chartDataSet)
    } // End of get expensese chart data
} // End of chart view helper struct
