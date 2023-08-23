//
//  Watchlist.swift
//  Quoteslist
//
//  Created by Beer Koala on 15.08.2023.
//

import Foundation
import RealmSwift

class Watchlist: Object {

    // swiftlint:disable:next identifier_name
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
    @Persisted var order: Int
    @Persisted var quotes: List<Quote>

    @discardableResult
    convenience init(name: String, quotes: [Quote]) {
        self.init()

        self.name = name
        self.quotes = List<Quote>()
        self.quotes.append(objectsIn: quotes)

        if let realm = try? Realm() {
            if let highestOrder = realm.objects(Watchlist.self).max(ofProperty: "order") as Int? {
                self.order = highestOrder + 1
            }

            try? realm.write {
                // Delete the object from the Realm
                realm.add(self)
            }
        }
    }

    func rename(to newName: String) {
        // Begin a write transaction
        self.realm?.beginWrite()

        self.name = newName

        // Commit the transaction
        try? self.realm?.commitWrite()
    }

    func remove() {
        try? self.realm?.write {
            // Delete the object from the Realm
            self.realm?.delete(self)
        }
    }

    func move(from sourceIndex: Int, to destinationIndex: Int) {

        // Begin a write transaction
        self.realm?.beginWrite()

        self.quotes.move(from: sourceIndex, to: destinationIndex)

        // Commit the transaction
        try? self.realm?.commitWrite()
    }

    func append(quote: Quote) {
        // Begin a write transaction
        self.realm?.beginWrite()

        self.quotes.append(quote)

        // Commit the transaction
        try? self.realm?.commitWrite()
    }

    func removeQuote(at index: Int) {
        // Begin a write transaction
        self.realm?.beginWrite()

        self.quotes.remove(at: index)

        // Commit the transaction
        try? self.realm?.commitWrite()
    }

    func updatePrices(from priceDictionary: [String: QuotePriceResponse]) {
        // Begin a write transaction
        self.realm?.beginWrite()

        self.quotes.forEach { quote in
            if let price = priceDictionary[quote.stockSymbol] {
                quote.askPrice = price.askPrice
                quote.bidPrice = price.bidPrice
                quote.lastPrice = price.latestPrice
            }
        }

        // Commit the transaction
        try? self.realm?.commitWrite()
    }

    static var `default`: Watchlist = Watchlist(name: "Defaults", quotes: [
        Quote(name: "Apple", stockSymbol: "AAPL", bidPrice: 150, askPrice: 152, lastPrice: 151),
        Quote(name: "Microsoft", stockSymbol: "MSFT", bidPrice: 50, askPrice: 52, lastPrice: 51),
        Quote(name: "Alphabet", stockSymbol: "GOOG", bidPrice: 100, askPrice: 102, lastPrice: 101)
    ])

}
