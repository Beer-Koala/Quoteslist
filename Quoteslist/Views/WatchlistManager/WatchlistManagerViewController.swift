//
//  WatchlistManagerViewController.swift
//  Quoteslist
//
//  Created by Beer Koala on 17.08.2023.
//

import UIKit

protocol WatchlistManagerView: AnyObject {
    func reloadTable(animating: Bool)
    func reload(items: [Watchlist])
}

class WatchlistManagerViewController: UIViewController {

    struct Constants {
        static let defaultRowHeight: CGFloat = 44
    }

    var presenter: WatchlistManagerPresenterProtocol!
    var tableViewDataSource: EditEnabledDiffableDataSource<Watchlist>?

    //    static let cellIdentifier = "quoteTableViewCell" // TODO: clear code - make it with constants

    @IBOutlet weak var tableView: UITableView?

    @IBAction func createWatchlistAction(_ sender: UIButton) {
        let alert = UIAlertController.nameWatchlistAlert(for: .create) { [weak self] newTitle in
            self?.presenter?.createNewWatchlist(with: newTitle)
        }
        self.present(alert, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = WatchlistManagerPresenter(view: self)

        self.configureView()
        self.setupTableView()
    }

    func configureView() { }

    private func setupTableView() {
        guard let tableView = self.tableView else { return }

        tableView.setEditing(true, animated: false)

        self.tableViewDataSource = EditEnabledDiffableDataSource(
            tableView: tableView
        ) { _, _, watchlist in

            let cell = UITableViewCell()
            var cellContent = cell.defaultContentConfiguration()
            cellContent.text = watchlist.name
            cell.contentConfiguration = cellContent

            let button = UIButton(frame: CGRect(x: CGFloat.zero,
                                                y: CGFloat.zero,
                                                width: Constants.defaultRowHeight,
                                                height: Constants.defaultRowHeight))
            button.setImage(UIImage.editImage, for: .normal)
            button.addTarget(self, action: #selector(self.editTapped(_:)), for: .touchUpInside)
            cell.editingAccessoryView = button

            return cell
        }

        // TODO: can I move this and next closures to EditEnabledDiffableDataSource?
        self.tableViewDataSource?.deleteClosure = { watchlist in
            self.presenter.remove(watchlist)
        }

        self.tableViewDataSource?.moveClosure = { sourceIndex, destinationIndex in
            self.presenter.moveWatchlist(from: sourceIndex, to: destinationIndex)
        }

        self.reloadTable(animating: false) // no need animation for initial showing
    }

    @objc func editTapped(_ sender: UIButton) {
        if let cell = sender.superview as? UITableViewCell,
           let indexPath = self.tableView?.indexPath(for: cell),
           let watchlist = self.presenter.watchlists[safe: indexPath.row] {

            let alert = UIAlertController.nameWatchlistAlert(for: .edit(watchlist.name)) { [weak self] newTitle in
                self?.presenter?.renameWatchlist(by: indexPath.row, newName: newTitle)
            }
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension WatchlistManagerViewController: WatchlistManagerView {

    func reloadTable(animating: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<SectionModel, Watchlist>()
        snapshot.appendSections([.main])
        snapshot.appendItems(self.presenter.watchlists)
        tableViewDataSource?.apply(snapshot, animatingDifferences: animating)
    }

    // reload all table not reload elements if hash not changed, so reload specified items
    func reload(items: [Watchlist]) {
        if var snapshot = self.tableViewDataSource?.snapshot() {
            snapshot.reloadItems(items)
            self.tableViewDataSource?.apply(snapshot)
        }
    }
}
