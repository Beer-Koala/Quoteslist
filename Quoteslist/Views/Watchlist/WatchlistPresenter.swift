//
//  WatchlistPresenter.swift
//  Quoteslist
//
//  Created by Beer Koala on 16.08.2023.
//

import Foundation

// MARK: -
// MARK: WatchlistPresenterProtocol

protocol WatchlistPresenterProtocol {

    var watchlists: [Watchlist] { get }
    var currentWatchlist: Watchlist { get }
    var showingQuotes: [Quote] { get }

    func set(current watchlist: Watchlist)
    func removeQuote(for quote: Quote)
    func moveQuote(from sourceIndex: Int, to destinationIndex: Int)
    func watchlistName() -> String
    func setSearchQuotesPresenter() -> SearchQuotesPresenter
    func startGettingPrices()
}

// MARK: -
// MARK: WatchlistPresenter

class WatchlistPresenter {

    private weak var view: WatchlistView?

    private(set) var watchlists: [Watchlist] = []
    var currentWatchlist: Watchlist

    var showingQuotes: [Quote] {
        return Array(self.currentWatchlist.quotes)
    }

    private var watchListsDataSource: WatchlistsDataSource
    private weak var searchQuotesPresenter: SearchQuotesPresenter?

    init(view: WatchlistView) {
        self.view = view
        let watchlistsDataSource = WatchlistsDataSourceImp()
        self.watchlists = watchlistsDataSource.fetchWatchlists()
        self.currentWatchlist = self.watchlists.first ?? Watchlist.default
        self.searchQuotesPresenter?.currentWatchlist = self.currentWatchlist
        self.watchListsDataSource = watchlistsDataSource

        watchlistsDataSource.observeWatchlistsChanges { [weak self] watchlists in
            self?.watchlists = watchlists
            self?.view?.setupPopUpButton()
        }

        self.startGettingPrices()
    }
}

// MARK: -
// MARK: extension WatchlistPresenterProtocol

extension WatchlistPresenter: WatchlistPresenterProtocol {

    func set(current watchlist: Watchlist) {
        self.currentWatchlist = watchlist
        self.view?.reloadTable(animating: false)

        self.startGettingPrices()
    }

    func removeQuote(for quote: Quote) {
        self.currentWatchlist.quotes.removeAll(where: { $0 == quote})
    }

    func moveQuote(from sourceIndex: Int, to destinationIndex: Int) {
        self.currentWatchlist.move(from: sourceIndex, to: destinationIndex)
    }

    func watchlistName() -> String {
        self.currentWatchlist.name
    }

    func setSearchQuotesPresenter() -> SearchQuotesPresenter {
        let searchQuotesPresenter = SearchQuotesPresenter(currentWatchlist: self.currentWatchlist)
        self.searchQuotesPresenter = searchQuotesPresenter
        return searchQuotesPresenter
    }

    func startGettingPrices() {
        NetworkManager.shared.startGettingPrices(for: self.showingQuotes) { priceDictionary in
            DispatchQueue.main.async {
                self.currentWatchlist.updatePrices(from: priceDictionary)
                self.view?.reloadTable(animating: false)
            }
        }
    }
}
