//
//  EditEnabledDiffableDataSource.swift
//  Quoteslist
//
//  Created by Beer Koala on 17.08.2023.
//

import UIKit

enum SectionModel: Hashable {

    case main
}

final class EditEnabledDiffableDataSource<MyType>: UITableViewDiffableDataSource<SectionModel, MyType>
where MyType: Hashable {

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return canEditRow?() ?? true
    }

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    var canEditRow: (() -> Bool)?
    var deleteClosure: ((MyType) -> Void)?
    var moveClosure: ((_ from: Int, _ to: Int) -> Void)?

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        super.tableView(tableView, commit: editingStyle, forRowAt: indexPath)

        guard let id = itemIdentifier(for: indexPath) else {
            return
        }
        if editingStyle == .delete {
            var currentSnapshot = self.snapshot()
            currentSnapshot.deleteItems([id])

            self.apply(currentSnapshot)

            self.deleteClosure?(id)
        }
    }

    override func tableView(_ tableView: UITableView,
                            moveRowAt sourceIndexPath: IndexPath,
                            to destinationIndexPath: IndexPath) {
        super.tableView(tableView, moveRowAt: sourceIndexPath, to: destinationIndexPath)

        self.moveClosure?(sourceIndexPath.row, destinationIndexPath.row)
    }

}
