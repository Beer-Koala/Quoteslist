//
//  Quote.swift
//  Quoteslist
//
//  Created by Beer Koala on 15.08.2023.
//

import Foundation

class Quote {
    var stockSymbol: String
    var bidPrice: Float
    var askPrice: Float
    var lastPrice: Float

    init(stockSymbol: String, bidPrice: Float, askPrice: Float, lastPrice: Float) {
        self.stockSymbol = stockSymbol
        self.bidPrice = bidPrice
        self.askPrice = askPrice
        self.lastPrice = lastPrice
    }
}
