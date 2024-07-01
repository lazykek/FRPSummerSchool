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

    var items: Observable<[CartItem]> {
        Observable.just([])
    }
    var cart: Observable<Int> {
        Observable.just(0)
    }

    // MARK: - Methods

    func addItem(id: String) {
    }

    func removeItem(id: String) {
    }

    // MARK: - Init

    private init() {
    }
}
