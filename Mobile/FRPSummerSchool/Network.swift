//
//  Network.swift
//  FRPSummerSchool
//
//  Created by Ilia Cherkasov on 16.06.2024.
//

import Foundation
import RxSwift
import RxCocoa

enum NetworkError: Error {
    case dataCorrupted
}

final class Network {

    // MARK: - Internal properties

    static let shared: Network  = .init()

    // MARK: - Private properties

    // MARK: - Init

    private init() {
    }

    // MARK: - Internal methods

    func setSearchText(_ text: String) {
    }

    // MARK: - Private methods
}
