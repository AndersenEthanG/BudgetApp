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
        viewDidLoad()
    } // End of View will appear
    
    
    // MARK: - Functions
    func fetchAssets() {
        AssetController.sharedInstance.fetchAssets { fetchedAssets in
            DispatchQueue.main.async {
                self.allAssets = fetchedAssets
                self.filterLiquidAssets()
                
                self.updateView()
            }
        }
    } // End of Fetch Assets
    
    func updateView() {
        if assetFilterSwitch.selectedSegmentIndex == 0 {
            dataAssets = allAssets
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
            totalAssetsLabel.text = ("$" + String(total))
        } else {
            totalAssetsLabel.text = "$0"
        }
    } // End of Update total asset label
    
    func filterLiquidAssets() {
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
        
        let saveNonLiquidAction = UIAlertAction(title: "Not Liquid", style: .default) { _ in
            let liquid = false
            // Save Code
            guard let name: String = alert.textFields![0].text,
                  let value: Double = Double(alert.textFields![1].text!) else { return }
            
            let newAsset = Asset(liquid: liquid, name: name, updatedDate: Date(), value: value)
            AssetController.sharedInstance.createAsset(newAsset: newAsset)
            
            self.fetchAssets()
        }
        alert.addAction(saveNonLiquidAction)
        
        let saveLiquidAction = UIAlertAction(title: "Liquid", style: .default) { _ in
            let liquid = true
            // Save Code
            guard let name: String = alert.textFields![0].text,
                  let value: Double = Double(alert.textFields![1].text!) else { return }
            
            let newAsset = Asset(liquid: liquid, name: name, updatedDate: Date(), value: value)
            AssetController.sharedInstance.createAsset(newAsset: newAsset)
            
            self.fetchAssets()
        }
        alert.addAction(saveLiquidAction)
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
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
        
        cell.textLabel?.text = asset.name
        cell.detailTextLabel?.text = ("$" + String(asset.value))

        return cell
    } // End of Cell configure

    // Delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    } // End of Delete Row
} // End of Extension
