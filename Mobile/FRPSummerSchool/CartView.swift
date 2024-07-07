//
//  CartView.swift
//  FRPSummerSchool
//
//  Created by Ilia Cherkasov on 07.07.2024.
//

import UIKit

final class CartView: UIView {

    // MARK: - UI

    private let countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Public properties

    var itemsCount: Int = 0 {
        didSet {
            countLabel.text = "Акций в корзине: \(itemsCount)"
        }
    }

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods

    private func setupUI() {
        addSubview(countLabel)
        NSLayoutConstraint.activate([
            countLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            countLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
