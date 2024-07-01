//
//  Network.swift
//  FRPSummerSchool
//
//  Created by Ilia Cherkasov on 16.06.2024.
//

import Foundation
import RxSwift

enum NetworkError: Error {
    case dataCorrupted
}

final class Network {

    // MARK: - Internal properties

    static let shared: Network  = .init()
    lazy var stocks: Observable<[Stock]> = {
        Observable.just([])
    }()

    // MARK: - Init

    private init() {
    }

    // MARK: - Private methods

}
