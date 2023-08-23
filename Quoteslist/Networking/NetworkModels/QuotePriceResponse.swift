//
//  QuotePriceResponse.swift
//  Quoteslist
//
//  Created by Beer Koala on 23.08.2023.
//

import Foundation

struct QuotePriceResponse: Decodable {

    let bidPrice: Float
    let askPrice: Float
    let latestPrice: Float

    // Custom initializer for decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let nestedContainer = try container.nestedContainer(keyedBy: NestedCodingKeys.self, forKey: .quote)

        self.bidPrice = try nestedContainer.decode(Float.self, forKey: .iexBidPrice)
        self.askPrice = try nestedContainer.decode(Float.self, forKey: .iexAskPrice)
        self.latestPrice = try nestedContainer.decode(Float.self, forKey: .latestPrice)
    }

    enum NestedCodingKeys: String, CodingKey {
        case iexBidPrice
        case iexAskPrice
        case latestPrice
    }

    enum CodingKeys: String, CodingKey {
        case quote
    }
}
