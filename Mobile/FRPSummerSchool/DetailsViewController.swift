//
//  DetailsViewController.swift
//  FRPSummerSchool
//
//  Created by Ilia Cherkasov on 16.06.2024.
//

import UIKit

final class DetailsViewController: UIViewController {

    // MARK: - Private properties

    private let id: String
    private let storage = Storage.shared

    // MARK: - UI

    private let colorView: UIView = {
        let colorView = UIImageView()
        colorView.translatesAutoresizingMaskIntoConstraints = false
        return colorView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 40)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let controls: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let plusButton: UIButton = {
        let button = UIButton()
        button.setTitle(" + ", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 40)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let minusButton: UIButton = {
        let button = UIButton()
        button.setTitle(" - ", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 40)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Lifecycle

    init(id: String) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Private methods

    private func updateUI(item: CartItem) {
        colorView.backgroundColor = item.stock.color
        titleLabel.text = "\(item.stock.name)"
        countLabel.text = "\(item.count)"
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground

        view.addSubview(colorView)
        view.addSubview(titleLabel)
        view.addSubview(controls)

        controls.addArrangedSubview(plusButton)
        controls.addArrangedSubview(countLabel)
        controls.addArrangedSubview(minusButton)

        NSLayoutConstraint.activate([
            colorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            colorView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            colorView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            colorView.heightAnchor.constraint(equalToConstant: 300),

            titleLabel.topAnchor.constraint(equalTo: colorView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            controls.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            controls.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            controls.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}
