//
//  NetworkManager.swift
//  Quoteslist
//
//  Created by Beer Koala on 22.08.2023.
//

import Foundation

class NetworkManager {

    // MARK: -
    // MARK: Singleton

    // Usualy it better pass NetworkManager through coordinator, but now architecture without coordinator,
    //      so done using singleton
    // By the way singleton guarantees, that func stopGettingPrices stopes gettingPrices in whole app

    static let shared = NetworkManager()
    private init() {}

    // MARK: -
    // MARK: Properties

    private static let timeInterval = 5.0
    private var getPriceTimer: Timer?
    private var activeGetPriceURL: URL?

    private var lastProcessedResponseTimestamp: TimeInterval = 0

    // MARK: -
    // MARK: Private

    private func sendRequest(url: URL, completion: @escaping (Result<Any, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                let error = NSError(domain: "NoDataError", code: 0, userInfo: nil)
                completion(.failure(error))
                return
            }

            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                completion(.success(jsonObject))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

    // MARK: -
    // MARK: Public

    func searchQuotes(by text: String, completion: @escaping (Result<Any, Error>) -> Void) {
        let url = URL.searchQuotes(by: text)
        self.sendRequest(url: url, completion: completion)
    }

    func getHistory(for quote: Quote, completion: @escaping (Result<Any, Error>) -> Void) {
        let url = URL.getHistory(for: quote)
        self.sendRequest(url: url, completion: completion)
    }

    func startGettingPrices(for quotes: [Quote], completion: @escaping (Result<Any, Error>) -> Void) {
        stopGettingPrices() // Stop any ongoing requests

        self.lastProcessedResponseTimestamp = 0

        self.activeGetPriceURL = URL.getPrices(for: quotes)

        let currentRequestTimestamp = Date().timeIntervalSince1970

        self.getPriceTimer = Timer.scheduledTimer(withTimeInterval: Self.timeInterval, repeats: true) { [weak self] _ in
            if let url = self?.activeGetPriceURL {
                self?.sendRequest(url: url) { [weak self] result in
                    if currentRequestTimestamp > self?.lastProcessedResponseTimestamp ?? 0 {
                        self?.lastProcessedResponseTimestamp = currentRequestTimestamp
                        completion(result)
                    }
                }
            }
        }
        self.getPriceTimer?.fire() // Perform the initial request
    }

    func stopGettingPrices() {
        self.getPriceTimer?.invalidate()
        self.getPriceTimer = nil
        self.activeGetPriceURL = nil
    }
}
