//
//  QuoteChartViewController.swift
//  Quoteslist
//
//  Created by Beer Koala on 23.08.2023.
//

import UIKit
import DGCharts

protocol QuoteChartView: AnyObject {
    func updateChart()
}

class QuoteChartViewController: UIViewController {

    var presenter: QuoteChartPresenterProtocol?

    @IBOutlet weak var descriptionLabel: UILabel?
    @IBOutlet weak var chartView: BarChartView?

    override func viewDidLoad() {
        self.title = presenter?.currentQuote.stockSymbol
        self.descriptionLabel?.text = presenter?.currentQuote.name
    }

}

extension QuoteChartViewController: QuoteChartView {
    func updateChart() {

    }
}
