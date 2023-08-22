//
//  URL+Extension.swift
//  Quoteslist
//
//  Created by Beer Koala on 22.08.2023.
//

import Foundation

extension URL {
    private static let apiToken = URLQueryItem(name: "token", value: "pk_224712be9b5b4fcd8bc457202e8ab2f3")

    private static let baseTastyworksURL = URL(string: "https://api.tastyworks.com/")!
    private static let baseIEXCloudURL = URL(string: "https://cloud.iexapis.com/stable/stock/")!

    static func searchQuotes(by text: String) -> URL {

        return baseTastyworksURL
            .appending(path: "symbols/search")
            .appending(path: text)
    }

    static func getPrices(for quotes: [Quote]) -> URL {

        let symbolsQueryParam = quotes.map { $0.stockSymbol }.joined(separator: ",")
        let queryItems =
        [
            URLQueryItem(name: "symbols", value: symbolsQueryParam),
            URLQueryItem(name: "types", value: "quote"),
            URLQueryItem(name: "filter", value: "symbol,iexBidPrice,iexAskPrice,latestPrice"),
            apiToken
        ]

        return baseIEXCloudURL
            .appending(path: "market/batch")
            .appending(queryItems: queryItems)
    }

    static func getHistory(for quote: Quote) -> URL {

        return baseIEXCloudURL
            .appending(path: quote.stockSymbol)
            .appending(path: "chart/1m")
            .appending(queryItems: [apiToken])
    }
}
