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
    let count: Int
}

final class Storage {

    // MARK: - Singleton

    static let shared: Storage = .init()

    // MARK: - Properties

    var items: BehaviorSubject<[Item]> = .init(value: [])

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
