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

    private var watchListsDataSource: WatchlistsDataSource

    init(view: WatchlistManagerView) {
        self.view = view
        let watchlistsDataSource = WatchlistsDataSourceImp()
        self.watchlists = watchlistsDataSource.fetchWatchlists()
        self.watchListsDataSource = watchlistsDataSource

        watchlistsDataSource.observeWatchlistsChanges(onChanging: { [weak self] watchlists in
            self?.watchlists = watchlists
            self?.view?.reloadTable(animating: true)
        }, onDeleting: { [weak self] watchlists in
            self?.watchlists = watchlists
            // row was deleted from tableView in EditEnabledDiffableDataSource
        })
    }
}

extension WatchlistManagerPresenter: WatchlistManagerPresenterProtocol {
    func remove(_ watchlist: Watchlist) {
        self.watchlists.removeAll { $0 == watchlist }
        watchlist.remove()
    }

    func moveWatchlist(from sourceIndex: Int, to destinationIndex: Int) {
        let movedQuote = self.watchlists.remove(at: sourceIndex)
        self.watchlists.insert(movedQuote, at: destinationIndex)
        self.watchListsDataSource.reorder(watchlists: self.watchlists)
    }

    func createNewWatchlist(with name: String) {
        Watchlist(name: name, quotes: [])
    }

    func renameWatchlist(by index: Int, newName: String) {
        if let watchlist = self.watchlists[safe: index] {
            watchlist.rename(to: newName)
        }
    }

}
