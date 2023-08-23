//
//  SearchQuotesResponse.swift
//  Quoteslist
//
//  Created by Beer Koala on 23.08.2023.
//

import Foundation

struct SearchQuotesResponse: Codable {
    struct Item: Codable, Hashable {
        let symbol: String
        let description: String

        // for updating data in SearchQuotesViewController
        func hash(into hasher: inout Hasher) {
            hasher.combine(symbol)
            hasher.combine(description)
        }

        func quote() -> Quote {
            return Quote(name: self.description, stockSymbol: self.symbol, bidPrice: 0, askPrice: 0, lastPrice: 0)
        }
    }

    let data: Data

    struct Data: Codable {
        let items: [Item]
    }
}
