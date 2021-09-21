//
//  Budget.swift
//  Budgeter
//
//  Created by Ethan Andersen on 9/4/21.
//

import Foundation

struct Budget {
    /// These should all be monthly values,
    let incomeTotal: Double
    let savingTotal: Double
    let reoccuringTotal: Double
    let rate: FilterBy = .month
    
} // End of Budget
