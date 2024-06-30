//
//  Storage.swift
//  FRPSummerSchool
//
//  Created by Ilia Cherkasov on 16.06.2024.
//

import Foundation
import RxSwift

struct Item: Equatable {
    let stock: Stock
    var count: Int
}

final class Storage {

    // MARK: - Singleton

    static let shared: Storage = .init()

    // MARK: - Properties

    var items: Observable<[Item]> {
        Observable.combineLatest(
            Network.shared.stocks,
            cartSubject
        )
        .observe(on: scheduler)
        .map { stocks, cart in
            stocks.map { Item(stock: $0, count: cart[$0.id] ?? 0) }
        }
    }
    private let cartSubject: BehaviorSubject<[String: Int]> = .init(value: [:])
    private let scheduler = SerialDispatchQueueScheduler(
        internalSerialQueueName: "StorageSerialQueue"
    )
    private let disposeBag = DisposeBag()

    // MARK: - Methods

    func addItem(id: String) {
        var cart = (try? cartSubject.value()) ?? [:]
        cart[id, default: 0] += 1
        cartSubject.onNext(cart)
    }

    func removeItem(id: String) {
        var cart = (try? cartSubject.value()) ?? [:]
        cart[id, default: 0] -= 1
        cart[id] = max(cart[id, default: 0], 0)
        cartSubject.onNext(cart)
    }

    // MARK: - Init

    private init() {
    }
}
