//
//  Network.swift
//  FRPSummerSchool
//
//  Created by Ilia Cherkasov on 16.06.2024.
//

import Foundation
import RxSwift

enum NetworkError: Error {
    case dataCorrupted
}

final class Network {

    // MARK: - Internal properties

    static let shared: Network  = .init()

    // MARK: - Init

    private init() {
    }

    // MARK: - Internal methods

    func loadTelevisions() -> Observable<[Television]> {
        load(request: URLRequest(url: URL(string: "http://127.0.0.1:8080/items")!))
    }

    // MARK: - Private methods

    private func load<T: Decodable>(request: URLRequest) -> Observable<T> {
        Observable.create { observer in
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard error == nil else {
                    observer.onError(error!)
                    return
                }
                guard
                    let data,
                    let items = try? JSONDecoder().decode(T.self, from: data)
                else {
                    observer.onError(NetworkError.dataCorrupted)
                    return
                }
                observer.onNext(items)
            }
            .resume()
            return Disposables.create()
        }
    }
}
