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

    var presenter: WatchlistPresenterProtocol!

    var tableViewDataSource: EditEnabledDiffableDataSource?

    static let cellIdentifier = "quoteTableViewCell" // TODO: clear code - make it with constants

    @IBOutlet weak var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = WatchlistPresenter(view: self)

        self.setup()
    }

    private func setup() {

        guard let tableView = self.tableView else { return }

        tableView.delegate = self

        self.tableViewDataSource = EditEnabledDiffableDataSource(tableView: tableView) { [weak self] tableView, _, stockSymbol in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellIdentifier) as? QuoteTableViewCell else {
                return UITableViewCell()
            }

            if let quote = self?.presenter.showingQuotes.first(where: { $0.stockSymbol == stockSymbol }) {
                cell.nameLabel?.text = quote.name
                cell.stockSymbolLabel?.text = quote.stockSymbol
                cell.bidPriceLabel?.text = String(quote.bidPrice)
                cell.askPriceLabel?.text = String(quote.askPrice)
                cell.lastPriceLabel?.text = String(quote.lastPrice)
            }

            return cell
        }

        self.tableViewDataSource?.deleteClosure = { stockSymbol in
            self.presenter.removeQuote(for: stockSymbol)
        }

        var snapshot = NSDiffableDataSourceSnapshot<QuotesSection, String>()
        snapshot.appendSections([.main])
        snapshot.appendItems(self.presenter.showingQuotes.map(\.stockSymbol))
        tableViewDataSource?.apply(snapshot, animatingDifferences: false)

        //TODO: maybe at last stages if can - make adapter with datasource to avoid using model from presenter here.
    }

}

extension WatchlistViewController: UITableViewDelegate {

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//    }

//    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
//
//    }

}

