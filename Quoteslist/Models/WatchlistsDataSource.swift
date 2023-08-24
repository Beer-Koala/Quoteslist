//
//  WatchlistsDataSource.swift
//  Quoteslist
//
//  Created by Beer Koala on 21.08.2023.
//

import RealmSwift

protocol WatchlistsDataSource {

    func fetchWatchlists() -> [Watchlist]
    // when moved, change var order and change order in watchlist. It's catched like deleting and moving work wrong
    // so made different processing of deleting rows
    func observeWatchlistsChanges(onChanging: @escaping ([Watchlist]) -> Void,
                                  onDeleting: (([Watchlist]) -> Void)?) // optional closure is escaping
    func reorder(watchlists: [Watchlist])
}

class WatchlistsDataSourceImp: WatchlistsDataSource {

    private var notificationToken: NotificationToken?
    private let watchlistsResults: Results<Watchlist>?

    init() {
        let realm = try? Realm()
        self.watchlistsResults = realm?.objects(Watchlist.self).sorted(byKeyPath: Watchlist.Constants.orderPropertyName)
    }

    func fetchWatchlists() -> [Watchlist] {
        if let watchlistResults = self.watchlistsResults {
            return Array(watchlistResults)
        } else {
            // realm can be nil if DB structure changes and no migrations.
            // In this case show just default watchlist
            return [Watchlist.getDefault()]
        }
    }

    func observeWatchlistsChanges(onChanging: @escaping ([Watchlist]) -> Void,
                                  onDeleting: (([Watchlist]) -> Void)?) {
        self.notificationToken = self.watchlistsResults?.observe { changes in
            switch changes {
            case .update(let watchlists, let deletingIndices, _, _):
                if deletingIndices.isEmpty {
                    onChanging(Array(watchlists))
                } else {
                    onDeleting?(Array(watchlists)) ?? onChanging(Array(watchlists))
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
