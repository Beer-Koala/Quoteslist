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

    mutating func safeInsert(_ newElement: Element, at index: Index) {
        if index <= self.endIndex {
            self.insert(newElement, at: index)
        } else {
            self.append(newElement)
        }
    }

    mutating func safeRemove(at index: Index) -> Element? {
        guard index >= self.startIndex && index < self.endIndex else {
            return nil
        }
        return self.remove(at: index)
    }
}
