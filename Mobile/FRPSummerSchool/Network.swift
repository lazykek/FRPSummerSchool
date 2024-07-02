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
    lazy var stocks: Observable<[Stock]> = {
        load(
            request:
                URLRequest(
                    url: URL(string: "http://127.0.0.1:8080/items")!
                )
        )
        .asObservable()
    }()

    // MARK: - Init

    private init() {
    }

    // MARK: - Private methods

    private func load<T: Decodable>(request: URLRequest) -> Single<T> {
        Single<T>.create { single in
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard error == nil else {
                    single(.failure(error!))
                    return
                }
                guard
                    let data,
                    let items = try? JSONDecoder().decode(T.self, from: data)
                else {
                    single(.failure(NetworkError.dataCorrupted))
                    return
                }
                single(.success(items))
            }
            .resume()
            return Disposables.create()
        }
    }
}
