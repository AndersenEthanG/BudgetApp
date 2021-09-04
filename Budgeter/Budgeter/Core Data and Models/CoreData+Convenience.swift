//
//  CoreData+Convenience.swift
//  Budgeter
//
//  Created by Ethan Andersen on 9/4/21.
//

import CoreData

extension Asset {
    @discardableResult convenience init(
        creationDate: Date = Date(),
        liquid: Bool,
        name: String,
        updatedDate: Date,
        value: Double,
        context: NSManagedObjectContext = CoreDataStack.context
    ) {
        self.init(context: context)
        self.creationDate = creationDate
        self.liquid = liquid
        self.name = name
        self.updatedDate = updatedDate
        self.value = value
    }
} // End of Asset


extension Debt {
    @discardableResult convenience init(
        amountOwed: Double,
        amountPaid: Double,
        creationDate: Date = Date(),
        name: String,
        updateDate: Date,
        value: Double,
        context: NSManagedObjectContext = CoreDataStack.context
    ) {
        self.init(context: context)
        self.amountOwed = amountOwed
        self.amountPaid = amountPaid
        self.creationDate = creationDate
        self.name = name
        self.updateDate = updateDate
        self.value = value
    }
} // End of Debt


extension Expense {
    @discardableResult convenience init(
        amount: Double,
        creationDate: Date = Date(),
        frequency: Int,
        name: String,
        updateDate: Date,
        context: NSManagedObjectContext = CoreDataStack.context
    ) {
        self.init(context: context)
        self.amount = amount
        self.creationDate = creationDate
        self.frequency = Int16(frequency)
        self.name = name
        self.updateDate = updateDate
    }
} // End of Expense


extension Income {
    @discardableResult convenience init(
        amount: Double,
        creationDate: Date = Date(),
        frequency: Int,
        name: String,
        taxPercent: Decimal,
        updatedDate: Date,
        context: NSManagedObjectContext = CoreDataStack.context
    ) {
        self.init(context: context)
        self.amount = amount
        self.creationDate = creationDate
        self.frequency = Int16(frequency)
        self.name = name
        self.taxPercent = NSDecimalNumber(decimal: taxPercent)
        self.updatedDate = updatedDate
    }
} // End of Income


extension Purchase {
    @discardableResult convenience init(
        amount: Double,
        creationDate: Date = Date(),
        name: String,
        context: NSManagedObjectContext = CoreDataStack.context
    ) {
        self.init(context: context)
        self.amount = amount
        self.creationDate = creationDate
        self.name = name
    }
} // End of Purchase


extension Saving {
    @discardableResult convenience init(
        amount: Double,
        frequency: Int,
        isPercent: Bool,
        name: String,
        context: NSManagedObjectContext = CoreDataStack.context
    ) {
        self.init(context: context)
        self.amount = amount
        self.frequency = Int16(frequency)
        self.isPercent = isPercent
        self.name = name
    }
} // End of Saving
