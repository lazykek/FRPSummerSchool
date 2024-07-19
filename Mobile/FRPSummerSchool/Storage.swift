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
    var items: Observable<[CartItem]> {
        Observable.combineLatest(
            stocksSubject,
            cartSubject
        )
        .map { stocks, cart in
            stocks.map { CartItem(stock: $0, count: cart[$0.id] ?? 0) }
        }
    }
    var cart: Observable<Int> {
        cartSubject
            .map { dict in
                dict.compactMap { _, value in value }.reduce(0, +)
            }
    }

    // MARK: - Public properties

    // MARK: - Private properties

    private let stocksSubject: BehaviorSubject<[Stock]> = .init(value: [])
    private let cartSubject: BehaviorSubject<[String: Int]> = .init(value: [:])
    private let synchronizationScheduler = SerialDispatchQueueScheduler(
        internalSerialQueueName: "StorageSerialQueue"
    )
    private let disposeBag = DisposeBag()

    // MARK: - Methods

    func addItem(id: String) {
        Observable.just(id)
            .observe(on: synchronizationScheduler)
            .subscribe(
                onNext: { [unowned self] id in
                    var cart = (try? cartSubject.value()) ?? [:]
                    cart[id, default: 0] += 1
                    cartSubject.onNext(cart)
                }
            )
            .disposed(by: disposeBag)
    }

    func removeItem(id: String) {
        Observable.just(id)
            .observe(on: synchronizationScheduler)
            .subscribe(
                onNext: { [unowned self] id in
                    var cart = (try? cartSubject.value()) ?? [:]
                    cart[id] = max(cart[id, default: 0] - 1, 0)
                    cartSubject.onNext(cart)
                }
            )
            .disposed(by: disposeBag)
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
