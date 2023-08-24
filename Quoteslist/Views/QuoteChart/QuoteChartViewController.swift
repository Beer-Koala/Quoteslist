//
//  QuoteChartViewController.swift
//  Quoteslist
//
//  Created by Beer Koala on 23.08.2023.
//

import UIKit
import DGCharts

// MARK: -
// MARK: QuoteChartView

protocol QuoteChartView: ErrorAlertPresentable, AnyObject {

    func updateChart()
}

// MARK: -
// MARK: QuoteChartViewController

class QuoteChartViewController: UIViewController {

    var presenter: QuoteChartPresenterProtocol?

    @IBOutlet private weak var descriptionLabel: UILabel?
    @IBOutlet private weak var chartView: BarChartView?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = presenter?.currentQuote.stockSymbol
        self.descriptionLabel?.text = presenter?.currentQuote.name

        self.chartView?.scaleXEnabled = false
        self.chartView?.scaleYEnabled = false
    }

}

// MARK: -
// MARK: extension QuoteChartView

extension QuoteChartViewController: QuoteChartView {

    func updateChart() {
        DispatchQueue.main.async { [weak self] in
            self?.setDataCount()
        }
    }

    private func setDataCount() {
        guard let chartDataAndFormatter = self.presenter?.getChartDataAndFormatter() else { return }

        self.chartView?.data = chartDataAndFormatter.chartData
        self.chartView?.xAxis.valueFormatter = chartDataAndFormatter.xAxisFormatter
    }

}
