//
//  WatchlistPresenter.swift
//  Quoteslist
//
//  Created by Beer Koala on 16.08.2023.
//

import Foundation

protocol WatchlistPresenterProtocol {

    var watchlists: [Watchlist] { get }
    var currentWatchlist: Watchlist { get }
    var showingQuotes: [Quote] { get }

    func set(current watchlist: Watchlist)
    func removeQuote(for quote: Quote)
    func moveQuote(from sourceIndex: Int, to destinationIndex: Int)
    func watchlistName() -> String
    func setSearchQuotesPresenter() -> SearchQuotesPresenter
}

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
    }
}

extension WatchlistPresenter: WatchlistPresenterProtocol {

    func set(current watchlist: Watchlist) {
        self.currentWatchlist = watchlist
        self.view?.reloadTable(animating: false)
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
}
