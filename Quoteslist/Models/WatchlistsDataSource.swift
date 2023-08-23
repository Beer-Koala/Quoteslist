//
//  WatchlistsDataSource.swift
//  Quoteslist
//
//  Created by Beer Koala on 21.08.2023.
//

import RealmSwift

protocol WatchlistsDataSource {
    func fetchWatchlists() -> [Watchlist]
    func observeWatchlistsChanges(onChanging: @escaping ([Watchlist]) -> Void)

    // when moved, change var order and change order in watchlist. It's catched like deleting and moving work wromg
    // so made different processing of deleting rows
    func observeWatchlistsChanges(onChanging: @escaping ([Watchlist]) -> Void,
                                  onDeleting: @escaping ([Watchlist]) -> Void)
    func reorder(watchlists: [Watchlist])
}

class WatchlistsDataSourceImp: WatchlistsDataSource {
    private var notificationToken: NotificationToken?
    private let watchlistsResults: Results<Watchlist>?

    init() {
        let realm = try? Realm()
        self.watchlistsResults = realm?.objects(Watchlist.self).sorted(byKeyPath: "order")
    }

    func fetchWatchlists() -> [Watchlist] {
        if let watchlistResults = self.watchlistsResults {
            return Array(watchlistResults)
        } else {
            // realm can be nil if DB structure changes and no migrations.
            // In this case show just default watchlist
            return [Watchlist.default]
        }
    }

    func observeWatchlistsChanges(onChanging: @escaping ([Watchlist]) -> Void) {
        self.observeWatchlistsChanges(onChanging: onChanging, onDeleting: onChanging)
    }

    func observeWatchlistsChanges(onChanging: @escaping ([Watchlist]) -> Void,
                                  onDeleting: @escaping ([Watchlist]) -> Void) {
        self.notificationToken = self.watchlistsResults?.observe { changes in
            switch changes {
            case .update(let watchlists, let deletingIndices, _, _):
                if deletingIndices.isEmpty {
                    onChanging(Array(watchlists))
                } else {
                    onDeleting(Array(watchlists))
                }
            default:
                break
            }
        }
    }

    func reorder(watchlists: [Watchlist]) {
        guard let realm = try? Realm() else { return }

        try? realm.write {
            for (index, watchlist) in watchlists.enumerated() {
                watchlist.order = index
            }
        }
    }

    deinit {
        notificationToken?.invalidate()
    }
}
