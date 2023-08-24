//
//  Watchlist.swift
//  Quoteslist
//
//  Created by Beer Koala on 15.08.2023.
//

import Foundation
import RealmSwift

// MARK: - Watchlist

class Watchlist: Object {

    // swiftlint:disable:next identifier_name
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
    @Persisted var order: Int
    @Persisted var quotes: List<Quote>

    // MARK: - Init

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
        }
    }

    // MARK: - Public

    func save() {
        try? realm?.write {
            realm?.add(self)
        }
    }

    func rename(to newName: String) {
        self.realm?.beginWrite()

        self.name = newName

        try? self.realm?.commitWrite()
    }

    func remove() {
        try? self.realm?.write {
            // Delete the object from the Realm
            self.realm?.delete(self)
        }
    }

    func move(from sourceIndex: Int, to destinationIndex: Int) {

        self.realm?.beginWrite()

        self.quotes.move(from: sourceIndex, to: destinationIndex)

        try? self.realm?.commitWrite()
    }

    func append(quote: Quote) {
        self.realm?.beginWrite()

        self.quotes.append(quote)

        try? self.realm?.commitWrite()
    }

    func removeQuote(at index: Int) {
        self.realm?.beginWrite()

        self.quotes.remove(at: index)

        try? self.realm?.commitWrite()
    }

    func updatePrices(from priceDictionary: [String: QuotePriceResponse]) {
        self.realm?.beginWrite()

        self.quotes.forEach { quote in
            if let price = priceDictionary[quote.stockSymbol] {
                quote.askPrice = price.askPrice
                quote.bidPrice = price.bidPrice
                quote.lastPrice = price.latestPrice
            }
        }

        try? self.realm?.commitWrite()
    }
}

    // MARK: - Default Wathclist

extension Watchlist {

    static func getDefault() -> Watchlist {
        let watchlist = Watchlist.default
        watchlist.save()
        return watchlist
    }

    fileprivate static var `default`: Watchlist = Watchlist(name: "Defaults", quotes: [
        Quote(name: "Apple", stockSymbol: "AAPL", bidPrice: 150, askPrice: 152, lastPrice: 151),
        Quote(name: "Microsoft", stockSymbol: "MSFT", bidPrice: 50, askPrice: 52, lastPrice: 51),
        Quote(name: "Alphabet", stockSymbol: "GOOG", bidPrice: 100, askPrice: 102, lastPrice: 101)
    ])

}
