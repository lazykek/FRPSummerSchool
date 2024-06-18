//
//  Storage.swift
//  FRPSummerSchool
//
//  Created by Ilia Cherkasov on 16.06.2024.
//

import Foundation
import RxSwift

struct Item {
    let television: Television
    var count: Int
}

final class Storage {

    // MARK: - Singleton

    static let shared: Storage = .init()

    // MARK: - Properties

    var items: BehaviorSubject<[Item]> = .init(value: [])
    private let disposeBag = DisposeBag()

    // MARK: - Methods

    func addItem(id: String) {
        Observable.combineLatest(
            items,
            Observable.just(id)
        )
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
        .take(1)
        .subscribe { [weak self] items, id in
            var items = items
            self?.items.onNext(items.decreaseCount(id: id))
        }
        .disposed(by: disposeBag)
    }

    // MARK: - Init

    private init() {
        Network.shared.loadTelevisions { [weak self] result in
            switch result {
            case .success(let televisions):
                self?.items.onNext(televisions.map { .init(television: $0, count: 0) })
            case .failure(let error):
                self?.items.onError(error)
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
