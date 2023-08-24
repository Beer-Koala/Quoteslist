//
//  WatchlistViewController.swift
//  Quoteslist
//
//  Created by Beer Koala on 15.08.2023.
//

import UIKit

// MARK: - WatchlistView

protocol WatchlistView: AnyObject {

    func updateSearchQuotesPresenter(watchlist: Watchlist)
    func setupPopUpButton()
    func reloadTable(animating: Bool)
}

// MARK: - WatchlistViewController

class WatchlistViewController: UIViewController {

    enum Constants {

        static let cellIdentifier = "quoteTableViewCell"
        static let segueIdentifier = "showWatchlists"

        static let manageWatchlists = "Manage watchlists"
    }

    var presenter: WatchlistPresenterProtocol?
    var tableViewDataSource: EditEnabledDiffableDataSource<Quote>?

    @IBOutlet private weak var tableView: UITableView?
    @IBOutlet private weak var showAllWatchlistsButton: UIButton?

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
                                               name: .quoteInSearchSelected,
                                               object: nil)
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.tableView?.setEditing(editing, animated: animated)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openChart" {
            if let destinationVC = segue.destination as? QuoteChartViewController {

                if let cell = sender as? UITableViewCell,
                   let indexPath = tableView?.indexPath(for: cell),
                   let quote = self.presenter?.displayedQuotes[safe: indexPath.row] {
                    let presenter = QuoteChartPresenter(view: destinationVC, currentQuote: quote)
                    destinationVC.presenter = presenter
                }
            }
        }
    }

    // MARK: - Private

    @objc private func handleNotification() {
        self.reloadTable(animating: false)
        self.presenter?.startGettingPrices()
    }

    private func configureSearchView() {
        guard let searchQuotesPresenter = self.presenter?.setSearchQuotesPresenter() else { return }
        let searchQuotesVC = SearchQuotesViewController(presenter: searchQuotesPresenter)
        let searchController = UISearchController(searchResultsController: searchQuotesVC)
        searchController.searchResultsUpdater = searchQuotesVC
        searchController.delegate = self
        self.navigationItem.searchController = searchController
    }

    private func configureView() {
        self.setupPopUpButton()

        self.title = self.presenter?.appTitle
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    private func setupTableView() {
        guard let tableView = self.tableView else { return }
        tableView.delegate = self

        self.tableViewDataSource = EditEnabledDiffableDataSource(
            tableView: tableView
        ) { tableView, _, quote in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier)
                    as? QuoteTableViewCell
            else { return UITableViewCell() }

            cell.fill(with: quote)
            return cell
        }

        self.tableViewDataSource?.deleteClosure = { [weak self] quote in
            self?.presenter?.removeQuote(for: quote)
        }

        self.tableViewDataSource?.moveClosure = { [weak self] sourceIndex, destinationIndex in
            self?.presenter?.moveQuote(from: sourceIndex, to: destinationIndex)
        }

        self.reloadTable(animating: false) // no need animation for initial showing
    }

}

// MARK: - extension WatchlistView

extension WatchlistViewController: WatchlistView {

    func updateSearchQuotesPresenter(watchlist: Watchlist) {
        (self.navigationItem.searchController?.searchResultsUpdater as? SearchQuotesView)?
            .setCurrent(watchlist)
    }

    func setupPopUpButton() {
        guard let presenter = self.presenter else { return }

        let actions = presenter.watchlists.map { watchlist in
            UIAction(title: watchlist.name,
                     state: watchlist == presenter.currentWatchlist ? .on : .off) { [weak self] _ in

                self?.presenter?.set(current: watchlist)
                self?.updateSearchQuotesPresenter(watchlist: watchlist)

                self?.setupPopUpButton()
            }
        }
        let actionsSubmenu = UIMenu(title: String.empty, options: .displayInline, children: actions)

        let manageWatchlists = UIAction(title: Constants.manageWatchlists, image: UIImage.edit) { [weak self] _ in
            self?.performSegue(withIdentifier: Constants.segueIdentifier, sender: nil)
        }
        let manageSubmenu = UIMenu(title: String.empty, options: .displayInline, children: [manageWatchlists])

        let menu = UIMenu(children: [actionsSubmenu, manageSubmenu])

        self.showAllWatchlistsButton?.setTitle(presenter.watchlistName(), for: .normal)
        self.showAllWatchlistsButton?.menu = menu

        self.showAllWatchlistsButton?.showsMenuAsPrimaryAction = true
    }

    @objc func reloadTable(animating: Bool) {
        guard let presenter = self.presenter else { return }

        var snapshot = NSDiffableDataSourceSnapshot<SectionModel, Quote>()
        snapshot.appendSections([.main])
        snapshot.appendItems(presenter.displayedQuotes)
        self.tableViewDataSource?.apply(snapshot, animatingDifferences: animating)
    }
}

// MARK: - extension UISearchControllerDelegate

extension WatchlistViewController: UISearchControllerDelegate {
    func didDismissSearchController(_ searchController: UISearchController) {
        self.reloadTable(animating: false)
    }
}

// MARK: - extension UITableViewDelegate

extension WatchlistViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
