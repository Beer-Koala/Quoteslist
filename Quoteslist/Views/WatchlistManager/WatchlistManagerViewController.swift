//
//  WatchlistManagerViewController.swift
//  Quoteslist
//
//  Created by Beer Koala on 17.08.2023.
//

import UIKit

protocol WatchlistManagerView: AnyObject {

}

class WatchlistManagerViewController: UIViewController, WatchlistManagerView {

    var presenter: WatchlistManagerPresenterProtocol!
    var tableViewDataSource: EditEnabledDiffableDataSource<Watchlist>?

    //    static let cellIdentifier = "quoteTableViewCell" // TODO: clear code - make it with constants

    @IBOutlet weak var tableView: UITableView?

    @IBAction func createWatchlistAction(_ sender: UIButton) {

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = WatchlistManagerPresenter(view: self)

        self.configureView()
        self.setupTableView()
    }

//    override func setEditing(_ editing: Bool, animated: Bool) {
//        super.setEditing(editing, animated: animated)
//        self.tableView?.setEditing(editing, animated: animated)
//    }

    func configureView() {
//        self.showAllWatchlistsButton?.titleLabel?.text = presenter.watchlistName()
//
//        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    private func setupTableView() {
        guard let tableView = self.tableView else { return }

        tableView.setEditing(true, animated: false)

        self.tableViewDataSource = EditEnabledDiffableDataSource(
            tableView: tableView
        ) { _, _, watchlist in
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellIdentifier) as? QuoteTableViewCell
//            else {
//                return UITableViewCell()
//            }

            let cell = UITableViewCell()
            var cellContent = cell.defaultContentConfiguration()
            cellContent.text = watchlist.name
            cell.contentConfiguration = cellContent

            return cell
        }

        self.tableViewDataSource?.deleteClosure = { watchlist in
            self.presenter.remove(watchlist)
        }

        self.tableViewDataSource?.moveClosure = { sourceIndex, destinationIndex in
            self.presenter.moveWatchlist(from: sourceIndex, to: destinationIndex)
        }

        var snapshot = NSDiffableDataSourceSnapshot<SectionModel, Watchlist>()
        snapshot.appendSections([.main])
        snapshot.appendItems(self.presenter.watchlists)
        tableViewDataSource?.apply(snapshot, animatingDifferences: false)
    }
}
