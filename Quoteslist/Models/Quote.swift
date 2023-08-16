//
//  Quote.swift
//  Quoteslist
//
//  Created by Beer Koala on 15.08.2023.
//

import Foundation

class Quote {
    var name: String // TODO: Check we realy need it
    var stockSymbol: String
    var bidPrice: Float
    var askPrice: Float
    var lastPrice: Float

    init(name: String, stockSymbol: String, bidPrice: Float, askPrice: Float, lastPrice: Float) {
        self.name = name
        self.stockSymbol = stockSymbol
        self.bidPrice = bidPrice
        self.askPrice = askPrice
        self.lastPrice = lastPrice
    }
}

extension Quote: Hashable {

    static func == (lhs: Quote, rhs: Quote) -> Bool {
        lhs.stockSymbol == rhs.stockSymbol
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(stockSymbol)
    }
}
