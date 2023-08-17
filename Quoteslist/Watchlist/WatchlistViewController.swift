//
//  ViewController.swift
//  Quoteslist
//
//  Created by Beer Koala on 15.08.2023.
//

import UIKit


protocol WatchlistView: AnyObject {

}

enum QuotesSection: Hashable {
    case main
}

class WatchlistViewController: UIViewController, WatchlistView {

    var presenter: WatchlistPresenter!

    var tableViewDataSource: EditEnabledDiffableDataSource?

    static let cellIdentifier = "quoteTableViewCell" // TODO: make it with constants

    @IBOutlet weak var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = WatchlistPresenter(view: self)

        self.setup()
    }

    private func setup() {

        guard let tableView = self.tableView else { return }

        self.tableViewDataSource = EditEnabledDiffableDataSource(tableView: tableView) { [weak self] tableView, _, stockSymbol in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellIdentifier) as? QuoteTableViewCell else {
                return UITableViewCell()
            }

            if let quote = self?.presenter.watchlist.quotes.first(where: { $0.stockSymbol == stockSymbol }) {
                cell.nameLabel?.text = quote.name
                cell.stockSymbolLabel?.text = quote.stockSymbol
                cell.bidPriceLabel?.text = String(quote.bidPrice)
                cell.askPriceLabel?.text = String(quote.askPrice)
                cell.lastPriceLabel?.text = String(quote.lastPrice)
            }

            return cell
        }
        self.tableViewDataSource?.deleteClosure = { stockSymbol in
            self.presenter.watchlist.quotes.removeAll(where: { $0.stockSymbol == stockSymbol})
        }

        var snapshot = NSDiffableDataSourceSnapshot<QuotesSection, String>()
        snapshot.appendSections([.main])
        snapshot.appendItems(self.presenter.watchlist.quotes.map(\.stockSymbol))
        tableViewDataSource?.apply(snapshot, animatingDifferences: false)
    }

}

