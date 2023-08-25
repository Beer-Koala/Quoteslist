//
//  ActivityIndicatorPresentable.swift
//  Quoteslist
//
//  Created by Beer Koala on 24.08.2023.
//

import UIKit

protocol ActivityIndicatorPresentable where Self: UIViewController {

    var activityIndicatorView: UIActivityIndicatorView { get set }
    var activityIndicatorDisplayed: Bool { get set }

    func showActivityIndicator()
    func hideActivityIndicator()
}

extension ActivityIndicatorPresentable {

    func showActivityIndicator() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            self.activityIndicatorView.style = .large
            self.activityIndicatorView.center = self.view.center
            self.activityIndicatorView.startAnimating()
            self.view.addSubview(activityIndicatorView)
            self.activityIndicatorDisplayed = true
        }
    }

    func hideActivityIndicator() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            self.activityIndicatorView.stopAnimating()
            self.activityIndicatorView.removeFromSuperview()
            self.activityIndicatorDisplayed = false
        }
    }
}
