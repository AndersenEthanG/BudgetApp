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
        uuid: String = UUID().uuidString,
        value: Double,
        context: NSManagedObjectContext = CoreDataStack.context
    ) {
        self.init(context: context)
        self.creationDate = creationDate
        self.liquid = liquid
        self.name = name
        self.updatedDate = updatedDate
        self.uuid = uuid
        self.value = value
    }
    
    static func == (lhs: Asset, rhs: Asset) -> Bool {
        return lhs.uuid == rhs.uuid
    }
} // End of Asset


extension Debt {
    @discardableResult convenience init(
        amountPaid: Double,
        creationDate: Date = Date(),
        name: String,
        updateDate: Date,
        uuid: String = UUID().uuidString,
        value: Double,
        context: NSManagedObjectContext = CoreDataStack.context
    ) {
        self.init(context: context)
        self.amountPaid = amountPaid
        self.creationDate = creationDate
        self.name = name
        self.updateDate = updateDate
        self.uuid = uuid
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
        uuid: String = UUID().uuidString,
        context: NSManagedObjectContext = CoreDataStack.context
    ) {
        self.init(context: context)
        self.amount = amount
        self.creationDate = creationDate
        self.frequency = Int16(frequency)
        self.name = name
        self.updateDate = updateDate
        self.uuid = uuid
    }
} // End of Expense


extension Income {
    @discardableResult convenience init(
        amountPerHour: Double,
        creationDate: Date = Date(),
        frequency: Int,
        name: String,
        updatedDate: Date,
        uuid: String = UUID().uuidString,
        context: NSManagedObjectContext = CoreDataStack.context
    ) {
        self.init(context: context)
        self.amountPerHour = amountPerHour
        self.creationDate = creationDate
        self.name = name
        self.updatedDate = updatedDate
        self.uuid = uuid
    }
} // End of Income


extension Purchase {
    @discardableResult convenience init(
        amount: Double,
        creationDate: Date = Date(),
        name: String,
        purchaseDate: Date,
        uuid: String = UUID().uuidString,
        context: NSManagedObjectContext = CoreDataStack.context
    ) {
        self.init(context: context)
        self.amount = amount
        self.creationDate = creationDate
        self.purchaseDate = purchaseDate
        self.name = name
        self.uuid = uuid
    }
} // End of Purchase


extension Saving {
    @discardableResult convenience init(
        amount: Double,
        frequency: Int,
        isPercent: Bool,
        name: String,
        uuid: String = UUID().uuidString,
        context: NSManagedObjectContext = CoreDataStack.context
    ) {
        self.init(context: context)
        self.amount = amount
        self.frequency = Int16(frequency)
        self.isPercent = isPercent
        self.name = name
        self.uuid = uuid
    }
} // End of Saving
