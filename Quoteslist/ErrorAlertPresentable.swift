//
//  ErrorAlertPresentable.swift
//  Quoteslist
//
//  Created by Beer Koala on 23.08.2023.
//

import UIKit

private enum Constants {

    static let error = "Error"
    // swiftlint:disable:next identifier_name
    static let ok = "OK"
}

protocol ErrorAlertPresentable where Self: UIViewController {

    func showErrorAlert(error: String)
}

extension ErrorAlertPresentable {

    func showErrorAlert(error: String) {
        let alertController = UIAlertController(title: Constants.error, message: error, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Constants.ok, style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
