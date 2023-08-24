//
//  QuoteTableViewCell.swift
//  Quoteslist
//
//  Created by Beer Koala on 16.08.2023.
//

import UIKit

class QuoteTableViewCell: UITableViewCell {

    @IBOutlet private weak var stockSymbolLabel: UILabel?
    @IBOutlet private weak var nameLabel: UILabel?
    @IBOutlet private weak var bidPriceLabel: UILabel?
    @IBOutlet private weak var askPriceLabel: UILabel?
    @IBOutlet private weak var lastPriceLabel: UILabel?

    func fill(with quote: Quote) {
        self.nameLabel?.text = quote.name
        self.stockSymbolLabel?.text = quote.stockSymbol
        self.bidPriceLabel?.text = String(quote.bidPrice)
        self.askPriceLabel?.text = String(quote.askPrice)
        self.lastPriceLabel?.text = String(quote.lastPrice)
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)

        bidPriceLabel?.isHidden = editing
        askPriceLabel?.isHidden = editing
        lastPriceLabel?.isHidden = editing
    }
}
