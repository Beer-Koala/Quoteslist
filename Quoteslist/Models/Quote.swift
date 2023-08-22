//
//  Quote.swift
//  Quoteslist
//
//  Created by Beer Koala on 15.08.2023.
//

import Foundation
import RealmSwift

class Quote: Object {
    @Persisted var name: String
    @Persisted var stockSymbol: String
    @Persisted var bidPrice: Float
    @Persisted var askPrice: Float
    @Persisted var lastPrice: Float

    convenience init(name: String, stockSymbol: String, bidPrice: Float, askPrice: Float, lastPrice: Float) {
        self.init()

        self.name = name
        self.stockSymbol = stockSymbol
        self.bidPrice = bidPrice
        self.askPrice = askPrice
        self.lastPrice = lastPrice
    }
}
