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

    var items: BehaviorSubject<[Item]> = .init(value: [])
    private let scheduler = SerialDispatchQueueScheduler(
        internalSerialQueueName: "StorageSerialQueue"
    )
    private let disposeBag = DisposeBag()

    // MARK: - Methods

    func addItem(id: String) {
        Observable.combineLatest(
            items,
            Observable.just(id)
        )
        .observe(on: scheduler)
        .take(1)
        .subscribe { [weak self] items, id in
            var items = items
            self?.items.onNext(items.increaseCount(id: id))
        }
        .disposed(by: disposeBag)
    }

    func removeItem(id: String) {
        Observable.combineLatest(
            items,
            Observable.just(id)
        )
        // Reentrancy anomaly
        // This is caused by the fact you are emitting elements into the subject while you’re reading from it, creating this instability
        .take(1)
        .subscribe { [weak self] items, id in
            var items = items
            self?.items.onNext(items.decreaseCount(id: id))
        }
        .disposed(by: disposeBag)
    }

    // MARK: - Init

    private init() {
        Network.shared.stocks
            .subscribe { [unowned self] in
                items.onNext($0.map { Item(stock: $0, count: 0) })
            } onError: { [unowned self] error in
                items.onError(error)
            }
            .disposed(by: disposeBag)
    }
}

private extension Array where Array.Element == Item {
    mutating func increaseCount(id: String) -> Self {
        guard
            let index = firstIndex(where: { $0.stock.id == id })
        else {
            return self
        }
        self[index].count += 1
        return self
    }

    mutating func decreaseCount(id: String) -> Self {
        guard
            let index = firstIndex(where: { $0.stock.id == id })
        else {
            return self
        }
        self[index].count -= 1
        self[index].count = Swift.max(self[index].count, 0)
        return self
    }
}
