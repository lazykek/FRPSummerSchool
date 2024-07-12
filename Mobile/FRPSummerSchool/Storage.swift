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
        stocksSubject
            .map { stocks in
                stocks.map { CartItem(stock: $0, count: 0) }
            }
    }
    private let stocksSubject: BehaviorSubject<[Stock]> = .init(value: [])
    private let disposeBag = DisposeBag()

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
        Network.shared.stocks
            .subscribe(stocksSubject)
            .disposed(by: self.disposeBag)
    }
}
