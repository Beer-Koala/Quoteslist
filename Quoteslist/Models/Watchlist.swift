//
//  Watchlist.swift
//  Quoteslist
//
//  Created by Beer Koala on 15.08.2023.
//

import Foundation

class Watchlist {
    var quotes: [Quote]

    init(quotes: [Quote]) {
        self.quotes = quotes
    }

    // TODO Remove mocking, when will be fetching data
    // mock data
    static var mock: Watchlist = Watchlist(quotes: [
        Quote(name: "Alphabet", stockSymbol: "GOOG", bidPrice: 100, askPrice: 102, lastPrice: 101),
        Quote(name: "Microsoft", stockSymbol: "MSFT", bidPrice: 50, askPrice: 52, lastPrice: 51),
        Quote(name: "Apple", stockSymbol: "AAPL", bidPrice: 150, askPrice: 152, lastPrice: 151),
        Quote(name: "TastyTrade", stockSymbol: "TT", bidPrice: 900, askPrice: 999.99, lastPrice: 998),
        Quote(name: "Meta", stockSymbol: "IDK", bidPrice: 5, askPrice: 7, lastPrice: 6),
        Quote(name: "My company", stockSymbol: "MC", bidPrice: 0.23, askPrice: 0.78, lastPrice: 0.55),
        Quote(name: "Another best company", stockSymbol: "ABC", bidPrice: 0.12, askPrice: 1, lastPrice: 0.99)
    ])

}
