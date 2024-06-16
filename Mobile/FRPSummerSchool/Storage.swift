//
//  Storage.swift
//  FRPSummerSchool
//
//  Created by Ilia Cherkasov on 16.06.2024.
//

import Foundation

final class Storage {

    // MARK: - Singleton

    static let shared: Storage = .init()

    // MARK: - Init

    private init() {
        Network.shared.loadTelevision { result in
            switch result {
            case .success(let items):
                print(items)
            case .failure(let error):
                break
            }
        }
    }
}
