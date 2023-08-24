//
//  UIAlertController+WatchlistNaming.swift
//  Quoteslist
//
//  Created by Beer Koala on 19.08.2023.
//

import UIKit

extension UIAlertController {

    enum NameWatchlistAlertType {
        case create
        case edit(String)

        fileprivate func texts() -> PresetAlertText {
            switch self {
            case .create:
                return PresetAlertText(title: "New Watchlist",
                                       message: "Enter a name for new watchlist",
                                       fieldPlaceholder: "New watchlist",
                                       fieldText: String.empty)
            case .edit(let fieldText):
                return PresetAlertText(title: "Edit Watchlist Name",
                                       message: "Enter a new name for this watchlist",
                                       fieldPlaceholder: "New name",
                                       fieldText: fieldText)
            }
        }
    }

    static func nameWatchlistAlert(for type: NameWatchlistAlertType,
                                   saveCallback: @escaping ((String) -> Void)) -> UIAlertController {
        let texts = type.texts()

        let alert = UIAlertController(title: texts.title, message: texts.message, preferredStyle: .alert)

        alert.addTextField { [weak alert] textField in
            textField.placeholder = texts.fieldPlaceholder
            textField.text = texts.fieldText
            textField.addTarget(alert, action: #selector(alert?.textFieldDidChange(_:)), for: .editingChanged)
        }

        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak alert] _ in
            let newTitle = alert?.textFields?.first?.text ?? String.empty
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

    fileprivate struct PresetAlertText {
        var title: String
        var message: String
        var fieldPlaceholder: String
        var fieldText: String
    }
}
