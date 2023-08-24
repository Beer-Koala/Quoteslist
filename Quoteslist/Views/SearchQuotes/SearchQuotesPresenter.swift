//
//  SearchQuotesPresenter.swift
//  Quoteslist
//
//  Created by Beer Koala on 23.08.2023.
//

import Foundation

// MARK: - SearchQuotesPresenterProtocol

protocol SearchQuotesPresenterProtocol {

    var foundQuotes: [SearchQuotesResponse.Item] { get }

    func selectedQuotes() -> [Quote]
    func searchQuotes(by text: String)
    func selectQuote(for index: Int)
    func setCurrent(_ watchlist: Watchlist)
}

// MARK: - SearchQuotesPresenter

class SearchQuotesPresenter {

    weak var view: SearchQuotesView?

    var currentWatchlist: Watchlist
    private(set) var foundQuotes: [SearchQuotesResponse.Item] = []

    init(currentWatchlist: Watchlist) {
        self.currentWatchlist = currentWatchlist
    }
}

// MARK: - extension SearchQuotesPresenterProtocol

extension SearchQuotesPresenter: SearchQuotesPresenterProtocol {

    func selectedQuotes() -> [Quote] {
        Array(self.currentWatchlist.quotes)
    }

    func searchQuotes(by text: String) {
        guard !text.isEmpty else {
            self.foundQuotes = []
            return
        }
        NetworkManager.shared.searchQuotes(by: text) { [weak self] response in
            self?.foundQuotes = response.data.items
            DispatchQueue.main.async { [weak self] in
                self?.view?.reloadTable(animating: true)
            }
        }
    }

    func selectQuote(for index: Int) {
        if let selectedFoundQuote = self.foundQuotes[safe: index] {
            if let index = self.currentWatchlist.quotes.firstIndex(where: {
                $0.stockSymbol == selectedFoundQuote.symbol
            }) {
                self.currentWatchlist.removeQuote(at: index)
            } else {
                self.currentWatchlist.append(quote: selectedFoundQuote.quote)
            }
            self.view?.reloadTable(animating: true)
        }
    }

    func setCurrent(_ watchlist: Watchlist) {
        self.currentWatchlist = watchlist
    }
}
