//
//  Storage.swift
//  FRPSummerSchool
//
//  Created by Ilia Cherkasov on 16.06.2024.
//

import Foundation
import RxSwift

struct CartItem: Equatable {
    let stock: Stock
    var count: Int
}

final class Storage {

    // MARK: - Singleton

    static let shared: Storage = .init()

    // MARK: - Properties

    // MARK: - Methods

    func addItem(id: String) {
    }

    func removeItem(id: String) {
    }

    func setSearchText(_ text: String) {
        Network.shared.setSearchText(text)
    }

    // MARK: - Init

    private init() {
    }
}
