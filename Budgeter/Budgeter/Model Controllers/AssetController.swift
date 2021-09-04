//
//  AssetController.swift
//  Budgeter
//
//  Created by Ethan Andersen on 9/4/21.
//

import CoreData

class AssetController {
    
    // MARK: - Properties
    static let sharedInstance = AssetController()
    var assets: [Asset] = []
    
    // Fetch Request
    private lazy var fetchRequest: NSFetchRequest<Asset> = {
        let request = NSFetchRequest<Asset>(entityName: "Asset")
        request.predicate = NSPredicate(value: true)
        return request
    }() // End of Fetch Request
    
    // MARK: - Functions
    func createAsset(newAsset: Asset) {
        assets.append(newAsset)
        CoreDataStack.saveContext()
    } // End of Create asset
    
    func fetchAssets() {
        assets = (try? CoreDataStack.context.fetch(fetchRequest)) ?? []
    } // End of Fetch asset
    
    func updateAsset() {
        CoreDataStack.saveContext()
    } // End of Update asset
    
    func deleteAsset(assetToDelete: Asset) {
        if let index = assets.firstIndex(of: assetToDelete) {
            assets.remove(at: index)
        }
        CoreDataStack.context.delete(assetToDelete)
        CoreDataStack.saveContext()
    } // End of Delete asset
    
} // End of Class
