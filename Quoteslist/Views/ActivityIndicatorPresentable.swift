//
//  ActivityIndicatorPresentable.swift
//  Quoteslist
//
//  Created by Beer Koala on 24.08.2023.
//

import Foundation

import UIKit

protocol ActivityIndicatorPresentable where Self: UIViewController {

    var activityIndicatorView: UIActivityIndicatorView? { get set }

    func showActivityIndicator()
    func hideActivityIndicator()
}

extension ActivityIndicatorPresentable {

    func showActivityIndicator() {
        if let activityIndicatorView = self.activityIndicatorView {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }

                activityIndicatorView.style = .large
                activityIndicatorView.center = self.view.center
                activityIndicatorView.startAnimating()
                self.view.addSubview(activityIndicatorView)
            }
        }
    }

    func hideActivityIndicator() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            self.activityIndicatorView?.stopAnimating()
            self.activityIndicatorView?.removeFromSuperview()
        }
    }
}
