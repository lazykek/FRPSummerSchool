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

    func loadTelevisions() {
        //URL(string: "http://127.0.0.1:8080/items")!
    }

    // MARK: - Private methods

}
