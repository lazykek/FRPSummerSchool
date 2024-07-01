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
        Observable.just([])
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
