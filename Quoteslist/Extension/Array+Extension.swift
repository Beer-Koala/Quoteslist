//
//  Array+Extension.swift
//  Quoteslist
//
//  Created by Beer Koala on 21.08.2023.
//

import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
