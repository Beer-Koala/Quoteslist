//
//  ViewController.swift
//  Quoteslist
//
//  Created by Beer Koala on 15.08.2023.
//

import UIKit

protocol WatchlistView: AnyObject {
    func setupPopUpButton()
    func reloadTable(animating: Bool)
}

class ResultVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBlue
    }
}

class WatchlistViewController: UIViewController {

    var presenter: WatchlistPresenterProtocol!
    var tableViewDataSource: EditEnabledDiffableDataSource<Quote>?
    let searchController = UISearchController(searchResultsController: ResultVC())

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

    private func configureView() {
        self.navigationItem.searchController = self.searchController
        self.setupPopUpButton()

        self.title = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    private func setupTableView() {
        guard let tableView = self.tableView else { return }

        self.tableViewDataSource = EditEnabledDiffableDataSource(
            tableView: tableView
        ) { tableView, _, quote in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellIdentifier) as? QuoteTableViewCell
            else { return UITableViewCell() }

            cell.fill(with: quote)
            return cell
        }

        self.tableViewDataSource?.deleteClosure = { quote in
            self.presenter.removeQuote(for: quote)
        }

        self.tableViewDataSource?.moveClosure = { sourceIndex, destinationIndex in
            self.presenter.moveQuote(from: sourceIndex, to: destinationIndex)
        }

        self.reloadTable(animating: false) // no need animation for initial showing
    }

}

extension WatchlistViewController: WatchlistView {

    func setupPopUpButton() {
        let actions = self.presenter.watchlists.map { watchlist in
            UIAction(title: watchlist.name,
                     state: watchlist == self.presenter.currentWatchlist ? .on : .off) { [weak self] _ in

                self?.presenter?.set(current: watchlist)
                self?.setupPopUpButton()
        } }

        let actionsSubmenu = UIMenu(title: String.empty, options: .displayInline, children: actions)

        let manageWatchlists = UIAction(title: "Manage watchlists", image: UIImage.editImage) { _ in
            self.performSegue(withIdentifier: "showWatchlists", sender: nil)
        }
        let manageSubmenu = UIMenu(title: String.empty, options: .displayInline, children: [manageWatchlists])

        let menu = UIMenu(children: [actionsSubmenu, manageSubmenu])

        self.showAllWatchlistsButton?.setTitle(self.presenter.watchlistName(), for: .normal)
        self.showAllWatchlistsButton?.menu = menu

        self.showAllWatchlistsButton?.showsMenuAsPrimaryAction = true
    }

    func reloadTable(animating: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<SectionModel, Quote>()
        snapshot.appendSections([.main])
        snapshot.appendItems(self.presenter.showingQuotes)
        tableViewDataSource?.apply(snapshot, animatingDifferences: animating)
    }
}
