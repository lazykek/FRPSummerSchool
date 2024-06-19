//
//  Storage.swift
//  FRPSummerSchool
//
//  Created by Ilia Cherkasov on 16.06.2024.
//

import Foundation

// TODO: Cart Item
struct Item: Equatable {
    let television: Television
    var count: Int
}

final class Storage {

    // MARK: - Singleton

    static let shared: Storage = .init()
    var onCartItems: (([Item]) -> ())?

    // MARK: - Properties

    // MARK: - Methods

    func addItem(id: String) {
    }

    func removeItem(id: String) {
    }

    // MARK: - Init

    private init() {
        Network.shared.loadTelevisions { [weak self] result in
            switch result {
            case .success(let televisions):
                self?.onCartItems?(televisions.map { Item(television: $0, count: 0) })
            case .failure(let failure):
                print(failure)
            }
        }
    }
}

private extension Array where Array.Element == Item {
    mutating func increaseCount(id: String) -> Self {
        guard
            let index = firstIndex(where: { $0.television.id == id })
        else {
            return self
        }
        self[index].count += 1
        return self
    }

    mutating func decreaseCount(id: String) -> Self {
        guard
            let index = firstIndex(where: { $0.television.id == id })
        else {
            return self
        }
        self[index].count -= 1
        self[index].count = Swift.max(self[index].count, 0)
        return self
    }
}
