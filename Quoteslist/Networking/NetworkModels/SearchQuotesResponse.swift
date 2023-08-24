//
//  SearchQuotesResponse.swift
//  Quoteslist
//
//  Created by Beer Koala on 23.08.2023.
//

import Foundation

struct SearchQuotesResponse: Codable {

    let data: Data
}

extension SearchQuotesResponse {

    struct Data: Codable {
        let items: [Item]
    }

    struct Item: Codable, Hashable {
        let symbol: String
        let description: String

        // for updating data in SearchQuotesViewController
        func hash(into hasher: inout Hasher) {
            hasher.combine(symbol)
            hasher.combine(description)
        }

        var quote: Quote {
            Quote(name: description, stockSymbol: symbol, bidPrice: 0, askPrice: 0, lastPrice: 0)
        }
    }
}
