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

    var appTitle: String? { get }
    var watchlists: [Watchlist] { get }
    var currentWatchlist: Watchlist { get }
    var displayedQuotes: [Quote] { get }

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

    var appTitle: String? {
        Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String
    }

    private weak var view: WatchlistView?

    private(set) var watchlists: [Watchlist] = []
    var currentWatchlist: Watchlist

    var displayedQuotes: [Quote] {
        return Array(self.currentWatchlist.quotes)
    }

    private var watchListsDataSource: WatchlistsDataSource
    private weak var searchQuotesPresenter: SearchQuotesPresenter?

    init(view: WatchlistView) {
        self.view = view
        let watchlistsDataSource = WatchlistsDataSourceImp()
        self.watchlists = watchlistsDataSource.fetchWatchlists()
        self.currentWatchlist = self.watchlists.first ?? Watchlist.getDefault()
        self.searchQuotesPresenter?.currentWatchlist = self.currentWatchlist
        self.watchListsDataSource = watchlistsDataSource

        watchlistsDataSource.observeWatchlistsChanges(onChanging: { [weak self] watchlists in
            self?.watchlists = watchlists
            self?.view?.setupPopUpButton()
        }, onDeleting: nil)

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
        NetworkManager.shared.startGettingPrices(for: self.displayedQuotes) { priceDictionary in
            DispatchQueue.main.async { [weak self] in
                self?.currentWatchlist.updatePrices(from: priceDictionary)
                self?.view?.reloadTable(animating: false)
            }
        }
    }
}
