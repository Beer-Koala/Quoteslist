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

    // TODO Remove mocking, when will be fetching data
    // mock data
    static var mock: Watchlist = Watchlist(name: "Defaults", quotes: [
        Quote(name: "Alphabet", stockSymbol: "GOOG", bidPrice: 100, askPrice: 102, lastPrice: 101),
        Quote(name: "Microsoft", stockSymbol: "MSFT", bidPrice: 50, askPrice: 52, lastPrice: 51),
        Quote(name: "Apple", stockSymbol: "AAPL", bidPrice: 150, askPrice: 152, lastPrice: 151),
        Quote(name: "TastyTrade", stockSymbol: "TT", bidPrice: 900, askPrice: 999.99, lastPrice: 998),
        Quote(name: "Meta", stockSymbol: "IDK", bidPrice: 5, askPrice: 7, lastPrice: 6),
        Quote(name: "My company", stockSymbol: "MC", bidPrice: 0.23, askPrice: 0.78, lastPrice: 0.55),
        Quote(name: "Another best company", stockSymbol: "ABC", bidPrice: 0.12, askPrice: 1, lastPrice: 0.99)
    ])

    static var mockWatchlists: [Watchlist] = [
        Watchlist.mock,
        Watchlist(name: "Defaults1", quotes: [
            Quote(name: "Alphabet", stockSymbol: "GOOG1", bidPrice: 102, askPrice: 102, lastPrice: 102),
            Quote(name: "Microsoft", stockSymbol: "MSFT1", bidPrice: 52, askPrice: 52, lastPrice: 52),
            Quote(name: "Apple", stockSymbol: "AAPL1", bidPrice: 152, askPrice: 152, lastPrice: 152),
            Quote(name: "TastyTrade", stockSymbol: "TT1", bidPrice: 902, askPrice: 999.92, lastPrice: 992),
            Quote(name: "Meta", stockSymbol: "IDK1", bidPrice: 2, askPrice: 2, lastPrice: 2),
            Quote(name: "Mycompany", stockSymbol: "MC1", bidPrice: 0.22, askPrice: 0.72, lastPrice: 0.52),
            Quote(name: "Anothercompany", stockSymbol: "ABC1", bidPrice: 0.12, askPrice: 2, lastPrice: 0.92)
        ]),
        Watchlist(name: "Defaults12", quotes: [
            Quote(name: "Alphabet", stockSymbol: "GOOG2", bidPrice: 100, askPrice: 102, lastPrice: 101),
            Quote(name: "Microsoft", stockSymbol: "MSFT2", bidPrice: 50, askPrice: 52, lastPrice: 51),
            Quote(name: "Apple", stockSymbol: "AAPL2", bidPrice: 150, askPrice: 152, lastPrice: 151),
            Quote(name: "TastyTrade", stockSymbol: "TT2", bidPrice: 900, askPrice: 999.99, lastPrice: 998),
            Quote(name: "Meta", stockSymbol: "IDK2", bidPrice: 5, askPrice: 7, lastPrice: 6),
            Quote(name: "Mycompany", stockSymbol: "MC2", bidPrice: 0.23, askPrice: 0.78, lastPrice: 0.55),
            Quote(name: "Anothercompany", stockSymbol: "ABC2", bidPrice: 0.12, askPrice: 1, lastPrice: 0.99)
        ]),
        Watchlist(name: "Defaults123", quotes: [
            Quote(name: "Alphabet", stockSymbol: "GOOG3", bidPrice: 100, askPrice: 102, lastPrice: 101),
            Quote(name: "Microsoft", stockSymbol: "MSFT3", bidPrice: 50, askPrice: 52, lastPrice: 51),
            Quote(name: "Apple", stockSymbol: "AAPL3", bidPrice: 150, askPrice: 152, lastPrice: 151),
            Quote(name: "TastyTrade", stockSymbol: "TT3", bidPrice: 900, askPrice: 999.99, lastPrice: 998),
            Quote(name: "Meta", stockSymbol: "IDK3", bidPrice: 5, askPrice: 7, lastPrice: 6),
            Quote(name: "Mycompany", stockSymbol: "MC3", bidPrice: 0.23, askPrice: 0.78, lastPrice: 0.55),
            Quote(name: "Anothercompany", stockSymbol: "ABC3", bidPrice: 0.12, askPrice: 1, lastPrice: 0.99)
        ])]

}
