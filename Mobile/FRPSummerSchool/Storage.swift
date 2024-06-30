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
            stocksSubject,
            cartSubject
        )
        .observe(on: scheduler)
        .map { stocks, cart in
            stocks.map { Item(stock: $0, count: cart[$0.id] ?? 0) }
        }
    }
    var cart: Observable<Int> {
        cartSubject.map { $0.count }.asObservable()
    }
    private let cartSubject: BehaviorSubject<[String: Int]> = .init(value: [:])
    private let stocksSubject: BehaviorSubject<[Stock]> = .init(value: [])
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
        if cart[id, default: 0] <= 0 {
            cart[id] = nil
        }
        cartSubject.onNext(cart)
    }

    // MARK: - Init

    private init() {
        Network.shared.stocks
            .subscribe(stocksSubject)
            .disposed(by: self.disposeBag)
    }
}
