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

class WatchlistViewController: UIViewController {

    var presenter: WatchlistPresenterProtocol!
    var tableViewDataSource: EditEnabledDiffableDataSource<Quote>?

    static let cellIdentifier = "quoteTableViewCell"

    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var showAllWatchlistsButton: UIButton?

    deinit {
        // Remove the observer when the object is deallocated
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.presenter = WatchlistPresenter(view: self)

        self.configureSearchView()
        self.configureView()
        self.setupTableView()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleNotification),
                                               name: .selectQuoteInSearchNotification,
                                               object: nil)
    }

    @objc private func handleNotification() {
        self.reloadTable(animating: false)
        self.presenter.startGettingPrices()
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.tableView?.setEditing(editing, animated: animated)
    }

    private func configureSearchView() {
        let searchQuotesVC = SearchQuotesViewController(presenter: self.presenter.setSearchQuotesPresenter())
        let searchController = UISearchController(searchResultsController: searchQuotesVC)
        searchController.searchResultsUpdater = searchQuotesVC
        searchController.delegate = self
        self.navigationItem.searchController = searchController
    }

    private func configureView() {
        self.setupPopUpButton()

        self.title = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    private func setupTableView() {
        guard let tableView = self.tableView else { return }
        tableView.delegate = self

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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openChart" {
            if let destinationVC = segue.destination as? QuoteChartViewController {

                if let cell = sender as? UITableViewCell,
                   let indexPath = tableView?.indexPath(for: cell),
                   let quote = self.presenter.showingQuotes[safe: indexPath.row] {
                    let presenter = QuoteChartPresenter(view: destinationVC, currentQuote: quote)
                    destinationVC.presenter = presenter
                }
            }
        }
    }

}

extension WatchlistViewController: WatchlistView {

    func setupPopUpButton() {
        let actions = self.presenter.watchlists.map { watchlist in
            UIAction(title: watchlist.name,
                     state: watchlist == self.presenter.currentWatchlist ? .on : .off) { [weak self] _ in

                guard let strongSelf = self else { return }

                strongSelf.presenter?.set(current: watchlist)

                (strongSelf.navigationItem.searchController?.searchResultsUpdater as? SearchQuotesView)?
                    .setCurrent(watchlist)

                strongSelf.setupPopUpButton()
            }
        }

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

    @objc func reloadTable(animating: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<SectionModel, Quote>()
        snapshot.appendSections([.main])
        snapshot.appendItems(self.presenter.showingQuotes)
        self.tableViewDataSource?.apply(snapshot, animatingDifferences: animating)
    }
}

extension WatchlistViewController: UISearchControllerDelegate {
    func didDismissSearchController(_ searchController: UISearchController) {
        self.reloadTable(animating: false)
    }
}

extension WatchlistViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
