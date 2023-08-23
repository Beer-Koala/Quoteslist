//
//  SearchQuotesPresenter.swift
//  Quoteslist
//
//  Created by Beer Koala on 23.08.2023.
//

import Foundation

// MARK: -
// MARK: SearchQuotesPresenterProtocol

protocol SearchQuotesPresenterProtocol {
    var findedQuotes: [SearchQuotesResponse.Item] { get }

    func selectedQuotes() -> [Quote]
    func searchQuotes(by text: String)
    func selectQuote(for index: Int)
    func setCurrent(_ watchlist: Watchlist)
}

// MARK: -
// MARK: SearchQuotesPresenter

class SearchQuotesPresenter {

    weak var view: SearchQuotesView?

    var currentWatchlist: Watchlist
    private(set) var findedQuotes: [SearchQuotesResponse.Item] = []

    init(currentWatchlist: Watchlist) {
        self.currentWatchlist = currentWatchlist
    }
}

// MARK: -
// MARK: Extension for SearchQuotesPresenterProtocol

extension SearchQuotesPresenter: SearchQuotesPresenterProtocol {

    func selectedQuotes() -> [Quote] {
        Array(self.currentWatchlist.quotes)
    }

    func searchQuotes(by text: String) {
        guard !text.isEmpty else {
            self.findedQuotes = []
            return
        }
        NetworkManager.shared.searchQuotes(by: text) { response in
            self.findedQuotes = response.data.items
            self.view?.reloadTable(animating: true)
        }
    }

    func selectQuote(for index: Int) {
        if let selectedFindedQuote = self.findedQuotes[safe: index] {
            if let index = self.currentWatchlist.quotes.firstIndex(where: {
                $0.stockSymbol == selectedFindedQuote.symbol
            }) {
                self.currentWatchlist.removeQuote(at: index)
            } else {
                self.currentWatchlist.append(quote: selectedFindedQuote.quote())
            }
            self.view?.reloadTable(animating: true)
        }
    }

    func setCurrent(_ watchlist: Watchlist) {
        self.currentWatchlist = watchlist
    }
}
