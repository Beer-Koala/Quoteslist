//
//  EditEnabledDiffableDataSource.swift
//  Quoteslist
//
//  Created by Beer Koala on 17.08.2023.
//

import UIKit

final class EditEnabledDiffableDataSource: UITableViewDiffableDataSource<QuotesSection, String> {

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    var deleteClosure: ((String) -> Void)?

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let id = itemIdentifier(for: indexPath) else {
            return
        }
        var currentSnapshot = snapshot()
        currentSnapshot.deleteItems([id])

        apply(currentSnapshot)

        deleteClosure?(id)
    }

}
