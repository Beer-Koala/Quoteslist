//
//  WatchlistManagerPresenter.swift
//  Quoteslist
//
//  Created by Beer Koala on 17.08.2023.
//

import Foundation

protocol WatchlistManagerPresenterProtocol {
    var watchlists: [Watchlist] { get }

    func remove(_ watchlist: Watchlist)
    func moveWatchlist(from sourceIndex: Int, to destinationIndex: Int)
}

class WatchlistManagerPresenter {
    private weak var view: WatchlistManagerView?
    private(set) var watchlists: [Watchlist]

    //    var showingWatchlists: [Watchlist] {
    //        self.watchlists
    //    }

    init(view: WatchlistManagerView) {
        self.view = view
        self.watchlists = Watchlist.mockWatchlists
    }

}

extension WatchlistManagerPresenter: WatchlistManagerPresenterProtocol {
    func remove(_ watchlist: Watchlist) { // Check!!!!!! name?
        //        self.watchlist.quotes.removeAll(where: { $0.stockSymbol == stockSymbol})
        // TODO: DB - remove from DB
    }

    func moveWatchlist(from sourceIndex: Int, to destinationIndex: Int) {
        let movedQuote = self.watchlists.remove(at: sourceIndex)
        self.watchlists.insert(movedQuote, at: destinationIndex)
        // TODO: DB - save changes to DB
    }

}
