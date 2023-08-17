//
//  WatchlistPresenter.swift
//  Quoteslist
//
//  Created by Beer Koala on 16.08.2023.
//

import Foundation

protocol WatchlistPresenterProtocol {

    var showingQuotes: [Quote] { get }
    func removeQuote(for stockSymbol: String) -> Void
}

class WatchlistPresenter {

    private weak var view: WatchlistView?

    private let watchlist: Watchlist

    var showingQuotes: [Quote] {
        self.watchlist.quotes
    }

    init(view: WatchlistView) {
        self.view = view
        self.watchlist = Watchlist.mock
    }

}

extension WatchlistPresenter: WatchlistPresenterProtocol {

    func removeQuote(for stockSymbol: String) -> Void {
        self.watchlist.quotes.removeAll(where: { $0.stockSymbol == stockSymbol})
        // TODO: DB - remove from DB
    }
}
