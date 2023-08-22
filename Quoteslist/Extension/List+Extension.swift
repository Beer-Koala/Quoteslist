//
//  List+Extension.swift
//  Quoteslist
//
//  Created by Beer Koala on 21.08.2023.
//

import RealmSwift

extension List {

    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }

    func removeAll(where predicate: (Element) -> Bool) {
            // Create a list of indices to remove
            let indicesToRemove = (0..<count).filter { predicate(self[$0]) }

            // Begin a write transaction
            self.realm?.beginWrite()

            // Remove the objects at the specified indices
            indicesToRemove.forEach { index in
                self.remove(at: index)
            }

            // Commit the transaction
            try? self.realm?.commitWrite()
        }
}
