//
//  PortfolioTableViewController.swift
//  Budgeter
//
//  Created by Ethan Andersen on 9/3/21.
//

import UIKit

class AssetsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var totalAssetsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var assetFilterSwitch: UISegmentedControl!
    
    
    // MARK: - Properties
    var dataAssets: [Asset] = []
    var allAssets: [Asset] = []
    var liquidAssets: [Asset] = []
    var nonLiquidAssets: [Asset] = []
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAssets()
        
        // Table View
        tableView.dataSource = self
        tableView.delegate = self
    } // End of View did load
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    } // End of View will appear
    
    
    // MARK: - Functions
    func fetchAssets() {
        AssetController.sharedInstance.fetchAssets { fetchedAssets in
            DispatchQueue.main.async {
                self.allAssets = []
                
                self.allAssets = fetchedAssets
                self.filterLiquidAssets()
                
                self.updateView()
            }
        }
    } // End of Fetch Assets
    
    func updateView() {
        dataAssets = []
        switch assetFilterSwitch.selectedSegmentIndex {
        case 0:
            dataAssets = allAssets
        case 1:
            dataAssets = liquidAssets
        case 2:
            dataAssets = nonLiquidAssets
        default:
            print("Is line \(#line) working?")
        }
        updateTotalAssetsLabel()
        tableView.reloadData()
    } // End of Update View
    
    func updateTotalAssetsLabel() {
        var total: Double = 0
        for asset in dataAssets {
            total += asset.value
        }
        if total > 0 {
            totalAssetsLabel.text = (total.formatDoubleToMoney())
        } else {
            totalAssetsLabel.text = "$0"
        }
    } // End of Update total asset label
    
    func filterLiquidAssets() {
        liquidAssets = []
        nonLiquidAssets = []
        for asset in allAssets {
            if asset.liquid == true {
                liquidAssets.append(asset)
            } else {
                nonLiquidAssets.append(asset)
            }
        }
    } // End of Function
    
    
    // MARK: - Actions
    @IBAction func newAssetBtn(_ sender: Any) {
        let alert = UIAlertController(title: "New Asset", message: "Anything worth anything", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Name?"
            textField.autocapitalizationType = .sentences
            textField.autocorrectionType = .default
        }
        alert.addTextField { textField in
            textField.placeholder = "Value?"
            textField.keyboardType = .numberPad
        }
        
        let saveLiquidAction = UIAlertAction(title: "Liquid", style: .default) { _ in
            let liquid = true
            // Save Code
            guard let name: String = alert.textFields![0].text,
                  let value: Double = Double(alert.textFields![1].text!) else { return }
            
            let newAsset = Asset(liquid: liquid, name: name, updatedDate: Date(), value: value)
            AssetController.sharedInstance.createAsset(newAsset: newAsset)
            
            self.fetchAssets()
        }
        
        let saveNonLiquidAction = UIAlertAction(title: "Not Liquid", style: .default) { _ in
            let liquid = false
            // Save Code
            guard let name: String = alert.textFields![0].text,
                  let value: Double = Double(alert.textFields![1].text!) else { return }
            
            let newAsset = Asset(liquid: liquid, name: name, updatedDate: Date(), value: value)
            AssetController.sharedInstance.createAsset(newAsset: newAsset)
            
            self.fetchAssets()
        }
        
        alert.addAction(saveLiquidAction)
        alert.addAction(saveNonLiquidAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    } // End of New Asset Button
    
    
    @IBAction func didChangeSegment(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            dataAssets = allAssets
        case 1:
            dataAssets = liquidAssets
        case 2:
            dataAssets = nonLiquidAssets
        default:
            print("Is line \(#line) working?")
        }
        
        updateView()
    } // End of Did segment change
    
} // End of Class


extension AssetsViewController: UITableViewDelegate, UITableViewDataSource {
    // Number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataAssets.count
    } // End of row count
    
    // Cell data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "assetCell", for: indexPath)
        let asset = dataAssets[indexPath.row]
        
        let moneyString: String = asset.value.formatDoubleToMoney()
        
        cell.textLabel?.text = asset.name
        cell.detailTextLabel?.text = (moneyString)
        
        return cell
    } // End of Cell configure
    
    // Did select row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var assetToEdit: Asset = dataAssets[indexPath.row]
        
        let alert = UIAlertController(title: assetToEdit.name, message: String(assetToEdit.value), preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "New Name?"
            textField.autocapitalizationType = .sentences
            textField.autocorrectionType = .default
        }
        alert.addTextField { textField in
            textField.placeholder = "New Value?"
            textField.keyboardType = .numberPad
        }
        
        let saveLiquidAction = UIAlertAction(title: "Liquid", style: .default) { _ in
            let liquid = true
            // Save Code
            let name: String = alert.textFields![0].text ?? assetToEdit.name!
            let value: Double = Double(alert.textFields![1].text!) ?? assetToEdit.value
            
            // Edit asset
            assetToEdit = Asset(liquid: liquid, name: name, updatedDate: Date(), value: value)
            AssetController.sharedInstance.updateAsset()
            
            // Delete old one
            let assetToDelete: Asset = self.dataAssets[indexPath.row]
            AssetController.sharedInstance.deleteAsset(assetToDeleteUUID: assetToDelete.uuid!)
            
            self.fetchAssets()
        }
        alert.addAction(saveLiquidAction)
        
        let saveNonLiquidAction = UIAlertAction(title: "Not Liquid", style: .default) { _ in
            let liquid = false
            // Save Code
            let name: String = alert.textFields![0].text ?? assetToEdit.name!
            let value: Double = Double(alert.textFields![1].text!) ?? assetToEdit.value
            
            // Edit asset
            assetToEdit = Asset(liquid: liquid, name: name, updatedDate: Date(), value: value)
            AssetController.sharedInstance.updateAsset()
            
            // Delete old one
            let assetToDelete: Asset = self.dataAssets[indexPath.row]
            AssetController.sharedInstance.deleteAsset(assetToDeleteUUID: assetToDelete.uuid!)
            
            self.fetchAssets()
        }
        alert.addAction(saveNonLiquidAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    } // End of did select row
    
    // Delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let assetToDelete: Asset = dataAssets[indexPath.row]
            
            AssetController.sharedInstance.deleteAsset(assetToDeleteUUID: assetToDelete.uuid!)
            
            fetchAssets()
            tableView.reloadData()
        }
    } // End of Delete Row
} // End of Extension
