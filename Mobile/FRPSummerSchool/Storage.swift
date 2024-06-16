//
//  Storage.swift
//  FRPSummerSchool
//
//  Created by Ilia Cherkasov on 16.06.2024.
//

import Foundation

struct Item {
    let television: Television
    let count: Int
}

final class Storage {

    // MARK: - Singleton

    static let shared: Storage = .init()

    // MARK: - Properties

    var onItems: (([Item]) -> Void)?

    // MARK: - Init

    private init() {
        Network.shared.loadTelevisions { [weak self] result in
            switch result {
            case .success(let televisions):
                self?.onItems?(televisions.map { .init(television: $0, count: 0) })
            case .failure(let error):
                break
            }
        }
    }
}
