//
//  QuoteTableViewCell.swift
//  Quoteslist
//
//  Created by Beer Koala on 16.08.2023.
//

import UIKit

class QuoteTableViewCell: UITableViewCell {

    @IBOutlet weak var stockSymbolLabel: UILabel?
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var bidPriceLabel: UILabel?
    @IBOutlet weak var askPriceLabel: UILabel?
    @IBOutlet weak var lastPriceLabel: UILabel?

    func fill(with quote: Quote) {
        self.nameLabel?.text = quote.name
        self.stockSymbolLabel?.text = quote.stockSymbol
        self.bidPriceLabel?.text = String(quote.bidPrice)
        self.askPriceLabel?.text = String(quote.askPrice)
        self.lastPriceLabel?.text = String(quote.lastPrice)
    }
}
