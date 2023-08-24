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
            activityIndicatorView.style = .large
            activityIndicatorView.center = view.center
            activityIndicatorView.startAnimating()
            view.addSubview(activityIndicatorView)
        }
    }

    func hideActivityIndicator() {
        self.activityIndicatorView?.stopAnimating()
        self.activityIndicatorView?.removeFromSuperview()
    }
}
