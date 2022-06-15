//
//  ChartsViewController.swift
//  Budgeter
//
//  Created by Ethan Andersen on 6/10/22.
//

import UIKit
import Charts

class ChartsViewController: UIViewController, ChartViewDelegate {

    // MARK: - Outlets
    @IBOutlet weak var segmentedController: UISegmentedControl!
    
    
    // MARK: - Properties
    var selectedChartSegment: Int = 1
    var purchasesChartData = LineChartData()
    var expensesChartData = LineChartData()
    var finalChartDataSource = LineChartData()
    
    
    lazy var lineChartView: LineChartView = {
        let chartView = LineChartView()
        chartView.backgroundColor = .white
        
        chartView.rightAxis.enabled = false
        chartView.xAxis.labelPosition = .bottom
        
        chartView.animate(xAxisDuration: 2.0)
        
        return chartView
    }() // End of Line chart view
    
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getChartData()
        
        lineChartView.delegate = self
        view.addSubview(lineChartView)
        
        lineChartView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.width)
        lineChartView.center = view.center
        lineChartView.isUserInteractionEnabled = false
        
        updateChartDataSource()
    } // End of View will appear
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        lineChartView.removeFromSuperview()
    } // End of View will dissapear
    
    
    // MARK: - Functions
    func getChartData() {
        self.purchasesChartData = ChartViewHelper().getPurchasesChartData()
        self.expensesChartData = ChartViewHelper().getExpensesChartData()
    } // End of Get chart data
    
    func updateChartDataSource() {
        if segmentedController.selectedSegmentIndex == 0 {
            finalChartDataSource = purchasesChartData
        } else if segmentedController.selectedSegmentIndex == 1 {
            finalChartDataSource = expensesChartData
        } // End of else if
        
        lineChartView.data = finalChartDataSource
    } // End of update chart data source
    
    
    // MARK: - Actions
    @IBAction func segmentDidChange(_ sender: Any) {
        updateChartDataSource()
    } // End of segment did change
    
} // End of View Controller
