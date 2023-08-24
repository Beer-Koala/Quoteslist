//
//  HistoryQuotePrice.swift
//  Quoteslist
//
//  Created by Beer Koala on 23.08.2023.
//

import Foundation

struct HistoryQuotePrice: Decodable {

    let closePrice: Double
    let date: Date

    var shortDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM"
        return dateFormatter.string(from: date)
    }

    // Custom initializer for decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.closePrice = try container.decode(Double.self, forKey: .closePrice)
        let dateString = try container.decode(String.self, forKey: .priceDate)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let parsedDate = dateFormatter.date(from: dateString) {
            self.date = parsedDate
        } else {
            self.date = Date()
        }
    }

    enum CodingKeys: String, CodingKey {
        case closePrice = "close"
        case priceDate
    }
}

// here is unused properties from response:
//    let high: Double
//    let low: Double
//    let open: Double
//    let symbol: String
//    let volume: Int
//    let id: String
//    let key: String
//    let subkey: String
//    let date: String
//    let updated: Int
//    let changeOverTime: Double
//    let marketChangeOverTime: Double
//    let uOpen: Double
//    let uClose: Double
//    let uHigh: Double
//    let uLow: Double
//    let uVolume: Int
//    let fOpen: Double
//    let fClose: Double
//    let fHigh: Double
//    let fLow: Double
//    let fVolume: Int
//    let label: String
//    let change: Double
//    let changePercent: Double
