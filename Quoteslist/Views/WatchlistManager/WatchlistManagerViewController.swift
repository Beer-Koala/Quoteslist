//
//  WatchlistManagerViewController.swift
//  Quoteslist
//
//  Created by Beer Koala on 17.08.2023.
//

import UIKit

// MARK: -
// MARK: WatchlistManagerView

protocol WatchlistManagerView: AnyObject {
    func reloadTable(animating: Bool)
}

// MARK: -
// MARK: WatchlistManagerViewController

class WatchlistManagerViewController: UIViewController {

    struct Constants {
        static let defaultRowHeight: CGFloat = 44
    }

    var presenter: WatchlistManagerPresenterProtocol?
    var tableViewDataSource: EditEnabledDiffableDataSource<Watchlist>?

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

        self.tableViewDataSource?.deleteClosure = { watchlist in
            self.presenter?.remove(watchlist)
        }

        self.tableViewDataSource?.moveClosure = { sourceIndex, destinationIndex in
            self.presenter?.moveWatchlist(from: sourceIndex, to: destinationIndex)
        }

        self.reloadTable(animating: false) // no need animation for initial showing
    }

    @objc func editTapped(_ sender: UIButton) {
        if let cell = sender.superview as? UITableViewCell,
           let indexPath = self.tableView?.indexPath(for: cell),
           let presenter = self.presenter,
           let watchlist = presenter.watchlists[safe: indexPath.row] {

            let alert = UIAlertController.nameWatchlistAlert(for: .edit(watchlist.name)) { [weak self] newTitle in
                self?.presenter?.renameWatchlist(by: indexPath.row, newName: newTitle)
            }
            self.present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: -
// MARK: extension WatchlistManagerView

extension WatchlistManagerViewController: WatchlistManagerView {

    func reloadTable(animating: Bool) {
        guard let presenter = self.presenter else { return }

        var snapshot = NSDiffableDataSourceSnapshot<SectionModel, Watchlist>()
        snapshot.appendSections([.main])
        snapshot.appendItems(presenter.watchlists)
        snapshot.reloadSections([.main]) // force push to reload, cause not change name in view if changed in model
        self.tableViewDataSource?.apply(snapshot, animatingDifferences: false)
    }
}
