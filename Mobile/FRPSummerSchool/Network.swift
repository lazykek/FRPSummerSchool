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

    // MARK: - Singleton

    static let shared: Network  = .init()

    // MARK: - Init

    private init() {
    }

    func loadTelevision(completion: @escaping (Result<[Television], Error>) -> ()) {
        let request = URLRequest(url: URL(string: "http://127.0.0.1:8080/items")!)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            guard
                let data,
                let items = try? JSONDecoder().decode([Television].self, from: data)
            else {
                completion(.failure(NetworkError.dataCorrupted))
                return
            }
            completion(.success(items))
        }
        .resume()
    }
}
