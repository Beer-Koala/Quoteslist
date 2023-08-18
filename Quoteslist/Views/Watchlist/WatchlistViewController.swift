//
//  ViewController.swift
//  Quoteslist
//
//  Created by Beer Koala on 15.08.2023.
//

import UIKit

protocol WatchlistView: AnyObject {

}

enum SectionModel: Hashable {
    case main
}

class WatchlistViewController: UIViewController, WatchlistView {

    var presenter: WatchlistPresenterProtocol!
    var tableViewDataSource: EditEnabledDiffableDataSource<String>?

    static let cellIdentifier = "quoteTableViewCell" // TODO: clear code - make it with constants

    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var showAllWatchlistsButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = WatchlistPresenter(view: self)

        self.configureView()
        self.setupTableView()
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.tableView?.setEditing(editing, animated: animated)
    }

    func configureView() {
        self.showAllWatchlistsButton?.titleLabel?.text = presenter.watchlistName()

        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    private func setupTableView() {
        guard let tableView = self.tableView else { return }

        self.tableViewDataSource = EditEnabledDiffableDataSource(
            tableView: tableView
        ) { [weak self] tableView, _, stockSymbol in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellIdentifier) as? QuoteTableViewCell
            else {
                return UITableViewCell()
            }

            if let quote = self?.presenter.showingQuotes.first(where: { $0.stockSymbol == stockSymbol }) {
                cell.fill(with: quote)
            }

            return cell
        }

        self.tableViewDataSource?.deleteClosure = { stockSymbol in
            self.presenter.removeQuote(for: stockSymbol)
        }

        self.tableViewDataSource?.moveClosure = { sourceIndex, destinationIndex in
            self.presenter.moveQuote(from: sourceIndex, to: destinationIndex)
        }

        var snapshot = NSDiffableDataSourceSnapshot<SectionModel, String>()
        snapshot.appendSections([.main])
        snapshot.appendItems(self.presenter.showingQuotes.map(\.stockSymbol))
        tableViewDataSource?.apply(snapshot, animatingDifferences: false)

        // TODO: maybe at last stages if can - make adapter with datasource to avoid using model from presenter here.
    }

}
