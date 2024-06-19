//
//  Network.swift
//  FRPSummerSchool
//
//  Created by Ilia Cherkasov on 16.06.2024.
//

import Foundation

enum NetworkError: Error {
    case dataCorrupted
}

final class Network {

    // MARK: - Internal properties

    static let shared: Network  = .init()

    // MARK: - Init

    private init() {}

    // MARK: - Internal methods

    func loadTelevisions(
        completion: @escaping (Result<[Television], Error>) -> ()
    ) {
        URLSession.shared.dataTask(
            with: URL(string: "http://127.0.0.1:8080/items")!
        ) { data, _, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            // передаем ошибку JSON
            guard
                let televisions = try? JSONDecoder().decode([Television].self, from: data ?? Data())
            else {
                completion(.failure(NetworkError.dataCorrupted))
                return
            }
            completion(.success(televisions))
        }
        .resume()
    }

    // MARK: - Private methods

}
