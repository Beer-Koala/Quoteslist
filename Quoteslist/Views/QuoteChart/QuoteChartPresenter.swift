//
//  QuoteChartPresenter.swift
//  Quoteslist
//
//  Created by Beer Koala on 23.08.2023.
//

import Foundation

// MARK: -
// MARK: QuoteChartPresenterProtocol

protocol QuoteChartPresenterProtocol {
    var currentQuote: Quote { get }
    var historyQuotePrice: [HistoryQuotePrice] { get }
}

// MARK: -
// MARK: QuoteChartPresenter

class QuoteChartPresenter {

    private(set) var currentQuote: Quote
    private(set) var historyQuotePrice: [HistoryQuotePrice] = []

    private weak var view: QuoteChartView?

    init(view: QuoteChartView, currentQuote: Quote) {
        self.view = view
        self.currentQuote = currentQuote

        NetworkManager.shared.getHistory(for: self.currentQuote) { [weak self] error in
            self?.view?.showErrorAlert(error: error.localizedDescription)
        } successCompletion: { historyQuotePrice in
            self.historyQuotePrice = historyQuotePrice
            self.view?.updateChart()
        }
    }
}

// MARK: -
// MARK: extension QuoteChartPresenterProtocol

extension QuoteChartPresenter: QuoteChartPresenterProtocol { }
