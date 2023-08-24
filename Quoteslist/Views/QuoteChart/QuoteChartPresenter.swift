//
//  QuoteChartPresenter.swift
//  Quoteslist
//
//  Created by Beer Koala on 23.08.2023.
//

import Foundation
import DGCharts

// MARK: - QuoteChartPresenterProtocol

protocol QuoteChartPresenterProtocol {

    var currentQuote: Quote { get }

    func getChartDataAndFormatter() -> (chartData: ChartData, xAxisFormatter: QuoteChartPresenter.CustomFormatter)
}

// MARK: - QuoteChartPresenter

class QuoteChartPresenter {

    private(set) var currentQuote: Quote
    private(set) var historyQuotePrice: [HistoryQuotePrice] = []

    private weak var view: QuoteChartView?

    init(view: QuoteChartView, currentQuote: Quote) {
        self.view = view
        self.currentQuote = currentQuote

        NetworkManager.shared.getHistory(for: self.currentQuote) { [weak self] error in
            self?.view?.showErrorAlert(error: error.localizedDescription)
        } successCompletion: { [weak self] historyQuotePrice in
            self?.historyQuotePrice = historyQuotePrice
            self?.view?.updateChart()
        }
    }
}

// MARK: - extension CustomFormatter

extension QuoteChartPresenter {

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

// MARK: - extension QuoteChartPresenterProtocol

extension QuoteChartPresenter: QuoteChartPresenterProtocol {

    func getChartDataAndFormatter() -> (chartData: ChartData, xAxisFormatter: QuoteChartPresenter.CustomFormatter) {
        var dates = [Double: String]()
        let dataEntries = historyQuotePrice.enumerated().map { (index, historyQuotePrice) in
            let doubleIndex = Double(index)
            dates[doubleIndex] = historyQuotePrice.shortDateString
            return BarChartDataEntry(
                x: doubleIndex,
                y: historyQuotePrice.closePrice)
        }

        let set = BarChartDataSet(entries: dataEntries, label: "Previous month")
        set.colors = [.gray]
        set.drawValuesEnabled = false
        set.highlightEnabled = false

        let data = BarChartData(dataSet: set)
        let formatter = CustomFormatter(using: dates)

        return (data, formatter)
    }
}
