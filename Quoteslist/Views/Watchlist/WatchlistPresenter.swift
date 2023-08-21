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
    func removeQuote(for stockSymbol: String)
    func moveQuote(from sourceIndex: Int, to destinationIndex: Int)
    func watchlistName() -> String
}

class WatchlistPresenter {

    private weak var view: WatchlistView?

    private(set) var watchlists: [Watchlist]
    var currentWatchlist: Watchlist

    var showingQuotes: [Quote] {
        self.currentWatchlist.quotes
    }

    init(view: WatchlistView) {
        self.view = view

        self.watchlists = Watchlist.mockWatchlists
        self.currentWatchlist = self.watchlists.first ?? Watchlist.mock
    }
}

extension WatchlistPresenter: WatchlistPresenterProtocol {

    func set(current watchlist: Watchlist) {
        self.currentWatchlist = watchlist
        self.view?.reloadTable(animating: false)
    }

    func removeQuote(for stockSymbol: String) {
        self.currentWatchlist.quotes.removeAll(where: { $0.stockSymbol == stockSymbol})
        // TODO: DB - remove from DB
    }

    func moveQuote(from sourceIndex: Int, to destinationIndex: Int) {
        if let movedQuote = self.currentWatchlist.quotes.safeRemove(at: sourceIndex) {
            self.currentWatchlist.quotes.safeInsert(movedQuote, at: destinationIndex)
            // TODO: DB - save changes to DB
        }
    }

    func watchlistName() -> String {
        self.currentWatchlist.name
    }
}
