//
//  ViewController.swift
//  Quoteslist
//
//  Created by Beer Koala on 15.08.2023.
//

import UIKit


protocol WatchlistView: AnyObject {

}

class WatchlistViewController: UIViewController, WatchlistView {

    var presenter: WatchlistPresenter!

    var diffableDataSource: UITableViewDiffableDataSource<Int, Quote>!
    var currentDataSourceSnapshot: NSDiffableDataSourceSnapshot<Int, Quote>!

    let cellIdentifier = "quoteTableViewCell"

    @IBOutlet weak var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = WatchlistPresenter(view: self)
        setup()
    }

    private func setup() {

        guard let tableView = self.tableView else { return }
        // Initialize Diffable data source
        diffableDataSource = UITableViewDiffableDataSource<Int, Quote>(tableView: tableView, cellProvider: { (tableView, indexPath, value) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as? QuoteTableViewCell

            cell?.nameLabel?.text = value.name
            cell?.stockSymbolLabel?.text = value.stockSymbol
            cell?.bidPriceLabel?.text = String(value.bidPrice)
            cell?.askPriceLabel?.text = String(value.askPrice)
            cell?.lastPriceLabel?.text = String(value.lastPrice)

            return cell
        })

        // Instantiate the new snapshot and append the data to the datasource
        addValuesToSnapshot(for: presenter.watchlist)
    }

    private func addValuesToSnapshot(for value: WatchList) {
        // Initialize Snapshot to apply to the data source
        var snapshot = NSDiffableDataSourceSnapshot<Int, Quote>()

        // Append values to the snapshot
        snapshot.appendSections([0])
        snapshot.appendItems(value.quotes, toSection: 0)

        // Save the current snapshot state
        self.currentDataSourceSnapshot = snapshot
        //dataSourceData = values

        //tableViewDataSource.apply(snapshot, animatingDifferences: false)
        self.diffableDataSource.apply(currentDataSourceSnapshot, animatingDifferences: true)
    }


}

