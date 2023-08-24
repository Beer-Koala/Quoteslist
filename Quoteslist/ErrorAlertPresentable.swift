//
//  ErrorAlertPresentable.swift
//  Quoteslist
//
//  Created by Beer Koala on 23.08.2023.
//

import UIKit

protocol ErrorAlertPresentable where Self: UIViewController {

    func showErrorAlert(error: String)
}

extension ErrorAlertPresentable {

    func showErrorAlert(error: String) {
        let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
