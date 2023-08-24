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

    private func sendRequest(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
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

            completion(.success(data))
        }
        task.resume()
    }

    // MARK: -
    // MARK: Public

    func searchQuotes(by text: String,
                      errorCompletion: ((Error) -> Void)? = nil,
                      successCompletion: @escaping (SearchQuotesResponse) -> Void) {
        guard let url = URL.searchQuotes(by: text) else { return }
        self.sendRequest(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(SearchQuotesResponse.self, from: data)
                    successCompletion(response)
                } catch {
                    errorCompletion?(error)
                }

            case .failure(let error):
                errorCompletion?(error)
            }
        }
    }

    func getHistory(for quote: Quote,
                    errorCompletion: ((Error) -> Void)? = nil,
                    successCompletion: @escaping ([HistoryQuotePrice]) -> Void) {
        guard let url = URL.getHistory(for: quote) else { return }
        self.sendRequest(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode([HistoryQuotePrice].self, from: data)
                    successCompletion(response)
                } catch {
                    errorCompletion?(error)
                }

            case .failure(let error):
                errorCompletion?(error)
            }
        }
    }

    func startGettingPrices(for quotes: [Quote],
                            errorCompletion: ((Error) -> Void)? = nil,
                            successCompletion: @escaping ([String: QuotePriceResponse]) -> Void) {
        self.stopGettingPrices() // Stop any ongoing requests

        self.lastProcessedResponseTimestamp = 0

        self.activeGetPriceURL = URL.getPrices(for: quotes)

        self.getPriceTimer = Timer.scheduledTimer(withTimeInterval: Self.timeInterval, repeats: true) { [weak self] _ in
            if let url = self?.activeGetPriceURL {
                let currentRequestTimestamp = Date().timeIntervalSince1970
                self?.sendRequest(url: url) { [weak self] result in
                    guard currentRequestTimestamp > self?.lastProcessedResponseTimestamp ?? TimeInterval.zero else {
                        return
                    }
                    self?.lastProcessedResponseTimestamp = currentRequestTimestamp
                    // Double-checking timestamp
                    guard currentRequestTimestamp >= self?.lastProcessedResponseTimestamp ?? TimeInterval.zero else {
                        return
                    }
                    switch result {
                    case .success(let data):
                        do {
                            let decoder = JSONDecoder()
                            let response = try decoder.decode([String: QuotePriceResponse].self, from: data)
                            successCompletion(response)
                        } catch {
                            errorCompletion?(error)
                        }

                    case .failure(let error):
                        errorCompletion?(error)
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
