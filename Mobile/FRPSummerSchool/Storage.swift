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

    // MARK: - Nested types

    private enum Event {
        case add(id: String)
        case remove(id: String)
    }

    // MARK: - Singleton

    static let shared: Storage = .init()

    // MARK: - Public properties

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

    // MARK: - Private properties

    private let cartSubject: BehaviorSubject<[String: Int]> = .init(value: [:])
    private let eventSubject: PublishSubject<Event> = .init()
    private let stocksSubject: BehaviorSubject<[Stock]> = .init(value: [])
    private let synchronizationScheduler = SerialDispatchQueueScheduler(
        internalSerialQueueName: "StorageSerialQueue"
    )
    private let disposeBag = DisposeBag()

    // MARK: - Methods

    func addItem(id: String) {
        eventSubject.onNext(.add(id: id))
    }

    func removeItem(id: String) {
        eventSubject.onNext(.remove(id: id))
    }

    func setSearchText(_ text: String) {
        Network.shared.setSearchText(text)
    }

    // MARK: - Init

    private init() {
        Network.shared.stocks
            .observe(on: synchronizationScheduler)
            .subscribe(stocksSubject)
            .disposed(by: disposeBag)

        eventSubject
            .observe(on: synchronizationScheduler)
            .withLatestFrom(cartSubject) { event, cart in
                var cart = cart
                switch event {
                case let .add(id):
                    cart[id, default: 0] += 1
                case let .remove(id):
                    cart[id] = max(cart[id, default: 0] - 1, 0)
                }
                return cart
            }
            .subscribe(cartSubject)
            .disposed(by: disposeBag)
    }
}
