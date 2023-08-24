//
//  SearchQuotesViewCotroller.swift
//  Quoteslist
//
//  Created by Beer Koala on 23.08.2023.
//

import UIKit

// MARK: - SearchQuotesView

protocol SearchQuotesView: UIViewController {

    func setCurrent(_ watchlist: Watchlist)
    func reloadTable(animating: Bool)
}

// MARK: - SearchQuotesViewController

// Others VC made in storyboard cause it is quicker. Here I made using XIB to show another (better?) way.
class SearchQuotesViewController: UIViewController {

    var presenter: SearchQuotesPresenterProtocol

    @IBOutlet private var tableView: UITableView?
    var tableViewDataSource: UITableViewDiffableDataSource<SectionModel, SearchQuotesResponse.Item>?

    init(presenter: SearchQuotesPresenter) {
        self.presenter = presenter
        super.init(nibName: "SearchQuotesViewController", bundle: nil)

        presenter.view = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupTableView()
    }

    // MARK: -
    // MARK: Private

    private func setupTableView() {
        guard let tableView = self.tableView else { return }

        tableView.delegate = self

        self.tableViewDataSource = EditEnabledDiffableDataSource(
            tableView: tableView
        ) { [weak self] _, _, quote in

            let cell = UITableViewCell()
            var cellContent = cell.defaultContentConfiguration()
            cellContent.text = quote.symbol
            cellContent.secondaryText = quote.description
            cell.contentConfiguration = cellContent

            if self?.presenter.selectedQuotes().contains(where: { $0.stockSymbol == quote.symbol }) ?? false {
                // Create an image view for the checkmark
                let checkmarkImageView = UIImageView(image: UIImage(systemName: "checkmark"))
                cell.accessoryView = checkmarkImageView
            }

            return cell
        }

        self.reloadTable(animating: false) // no need animation for initial showing
    }

}

// MARK: - extension UISearchResultsUpdating

extension SearchQuotesViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text ?? String.empty
        self.presenter.searchQuotes(by: text)
    }
}

// MARK: - extension SearchQuotesView

extension SearchQuotesViewController: SearchQuotesView {

    func reloadTable(animating: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<SectionModel, SearchQuotesResponse.Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(self.presenter.foundQuotes)
        snapshot.reloadSections([.main]) // force push to reload, cause hash not changed if changed selection
        self.tableViewDataSource?.apply(snapshot, animatingDifferences: animating)
    }
}

// MARK: - extension UITableViewDelegate

extension SearchQuotesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presenter.selectQuote(for: indexPath.row)
        NotificationCenter.default.post(name: .quoteInSearchSelected, object: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func setCurrent(_ watchlist: Watchlist) {
        self.presenter.setCurrent(watchlist)
    }
}
