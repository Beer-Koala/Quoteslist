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

    func createNewWatchlist(with name: String)
    func renameWatchlist(by index: Int, newName: String)
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
    func remove(_ watchlist: Watchlist) {
        self.watchlists.removeAll { $0 == watchlist }
        // TODO: DB - remove from DB
    }

    func moveWatchlist(from sourceIndex: Int, to destinationIndex: Int) {
        let movedQuote = self.watchlists.remove(at: sourceIndex)
        self.watchlists.insert(movedQuote, at: destinationIndex)
        // TODO: DB - save changes to DB
    }

    func createNewWatchlist(with name: String) {
        let randomInt1 = Int.random(in: 1..<100)
        let randomInt2 = Int.random(in: 1..<100)
        let randomInt3 = Int.random(in: 1..<100)

        let newWatchlist = Watchlist(name: name, quotes: [
        Quote(name: "new Quote \(randomInt1)", stockSymbol: "AA\(randomInt1)", bidPrice: Float.random(in: 1..<100), askPrice: Float.random(in: 1..<100), lastPrice: Float.random(in: 1..<100)),
        Quote(name: "new Quote \(randomInt2)", stockSymbol: "AA\(randomInt2)", bidPrice: Float.random(in: 1..<100), askPrice: Float.random(in: 1..<100), lastPrice: Float.random(in: 1..<100)),
        Quote(name: "new Quote \(randomInt3)", stockSymbol: "AA\(randomInt3)", bidPrice: Float.random(in: 1..<100), askPrice: Float.random(in: 1..<100), lastPrice: Float.random(in: 1..<100))
        ])

        self.watchlists.append(newWatchlist)
        // TODO: DB - save new watchlist to DB
        self.view?.reloadTable(animating: true)
    }

    func renameWatchlist(by index: Int, newName: String) {
        if let watchlist = self.watchlists[safe: index] {
            watchlist.name = newName
            self.view?.reload(items: [watchlist])
        }
    }

}
