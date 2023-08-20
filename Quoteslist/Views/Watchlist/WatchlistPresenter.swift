//
//  WatchlistPresenter.swift
//  Quoteslist
//
//  Created by Beer Koala on 16.08.2023.
//

import Foundation

protocol WatchlistPresenterProtocol {

    var showingQuotes: [Quote] { get }

    func removeQuote(for stockSymbol: String)
    func moveQuote(from sourceIndex: Int, to destinationIndex: Int)
    func watchlistName() -> String
}

class WatchlistPresenter {

    private weak var view: WatchlistView?

    private var watchlist: Watchlist

    var showingQuotes: [Quote] {
        self.watchlist.quotes
    }

    init(view: WatchlistView) {
        self.view = view
        self.watchlist = Watchlist.mock
    }
}

extension WatchlistPresenter: WatchlistPresenterProtocol {

    func removeQuote(for stockSymbol: String) {
        self.watchlist.quotes.removeAll(where: { $0.stockSymbol == stockSymbol})
        // TODO: DB - remove from DB
    }

    func moveQuote(from sourceIndex: Int, to destinationIndex: Int) {
        if let movedQuote = self.watchlist.quotes.safeRemove(at: sourceIndex) {
            self.watchlist.quotes.safeInsert(movedQuote, at: destinationIndex)
            // TODO: DB - save changes to DB
        }
    }

    func watchlistName() -> String {
        self.watchlist.name
    }
}
