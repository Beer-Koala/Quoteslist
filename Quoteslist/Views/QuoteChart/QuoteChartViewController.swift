//
//  QuoteChartViewController.swift
//  Quoteslist
//
//  Created by Beer Koala on 23.08.2023.
//

import UIKit
import DGCharts

protocol QuoteChartView: ErrorAlertPresentable, AnyObject {
    func updateChart()
}

class QuoteChartViewController: UIViewController {

    var presenter: QuoteChartPresenterProtocol?

    @IBOutlet weak var descriptionLabel: UILabel?
    @IBOutlet weak var chartView: BarChartView?

    override func viewDidLoad() {
        self.title = presenter?.currentQuote.stockSymbol
        self.descriptionLabel?.text = presenter?.currentQuote.name

        self.chartView?.scaleXEnabled = false
        self.chartView?.scaleYEnabled = false
    }

}

extension QuoteChartViewController: QuoteChartView {
    func updateChart() {
        DispatchQueue.main.async { [weak self] in
            self?.setDataCount()
        }
    }

    func setDataCount() {
        var dates = [Double: String]()
        let dataEntries = self.presenter?.historyQuotePrice.enumerated().map { (index, historyQuotePrice) in
            let doubleIndex = Double(index)
            dates[doubleIndex] = historyQuotePrice.shortDateString
            return BarChartDataEntry(
                x: doubleIndex,
                y: historyQuotePrice.closePrice)
        }

        guard let dataEntries = dataEntries else { return }

        let set = BarChartDataSet(entries: dataEntries, label: "Previous month")
        set.colors = [.gray]
        set.drawValuesEnabled = false
        set.highlightEnabled = false

        let data = BarChartData(dataSet: set)
        self.chartView?.data = data

        let formatter = CustomFormatter(using: dates)
        self.chartView?.xAxis.valueFormatter = formatter
    }

    class CustomFormatter: AxisValueFormatter {

        let dates: [Double: String]

        init(using dates: [Double: String]) {
            self.dates = dates
        }

        // A function that returns the formatted value for a given x value
        func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            // Return the order as a string, or an empty string if not found
            return self.dates[value] ?? String(value)
        }
    }
}
