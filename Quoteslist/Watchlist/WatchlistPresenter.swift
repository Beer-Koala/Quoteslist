//
//  WatchlistPresenter.swift
//  Quoteslist
//
//  Created by Beer Koala on 16.08.2023.
//

import Foundation

class WatchlistPresenter {

    private weak var view: WatchlistView?

    //private //TODO: make private again
    let watchlist: WatchList

    init(view: WatchlistView) {
        self.view = view
        self.watchlist = WatchList.mock
    }

}
