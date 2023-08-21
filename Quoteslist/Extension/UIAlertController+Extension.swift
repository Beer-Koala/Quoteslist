//
//  UIAlertController+Extension.swift
//  Quoteslist
//
//  Created by Beer Koala on 19.08.2023.
//

import UIKit

extension UIAlertController {

    enum NameWatchlistAlertType {
        case create
        case edit(String)

        // swiftlint:disable:next large_tuple
        func texts() -> (title: String, message: String, fieldPlaceholder: String, fieldText: String) {
            switch self {
            case .create:
                return ("New Watchlist", "Enter a name for new watchlist", "New watchlist", String.empty)
            case .edit(let fieldText):
                return ("Edit Watchlist Name", "Enter a new name for this watchlist", "New name", fieldText)
            }
        }
    }

    static func nameWatchlistAlert(
        for type: NameWatchlistAlertType,
        saveCallback: @escaping ((String) -> Void)
    ) -> UIAlertController {
        let texts = type.texts()

        let alert = UIAlertController(title: texts.title, message: texts.message, preferredStyle: .alert)

        alert.addTextField { [weak alert] textField in
            textField.placeholder = texts.fieldPlaceholder
            textField.text = texts.fieldText
            textField.addTarget(alert, action: #selector(alert?.textFieldDidChange(_:)), for: .editingChanged)
        }

        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak alert] _ in
            let newTitle = alert?.textFields?.first?.text ?? ""
            saveCallback(newTitle)
        }
        saveAction.isEnabled = !(texts.fieldText.isEmpty)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            // There's nothing to see here
        }

        alert.addAction(saveAction)
        alert.addAction(cancelAction)

        return alert
    }

    @objc fileprivate func textFieldDidChange(_ sender: UITextField) {
        self.actions.first { $0.title == "Save" }?.isEnabled = !(sender.text?.isEmpty ?? true)
    }

}
