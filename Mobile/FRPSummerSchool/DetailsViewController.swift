//
//  DetailsViewController.swift
//  FRPSummerSchool
//
//  Created by Ilia Cherkasov on 16.06.2024.
//

import UIKit
import RxSwift

final class DetailsViewController: UIViewController {

    // MARK: - Properties

    private let id: String
    private let storage = Storage.shared
    private let disposeBag = DisposeBag()

    // MARK: - UI

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .lightGray
        return imageView
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

        plusButton.addAction(
            .init(handler: { [unowned self] _ in
                storage.addItem(id: id)
            }),
            for: .touchUpInside
        )

        minusButton.addAction(
            .init(handler: { [unowned self] _ in
                storage.removeItem(id: id)
            }),
            for: .touchUpInside
        )

        storage.items
            .compactMap { [unowned self] items in
                items.first(where: { $0.television.id == id })
            }
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [unowned self] item in
                    updateUI(item: item)
                }, onError: { error in
                    print(error)
                }
            )
            .disposed(by: disposeBag)
    }

    // MARK: - Private methods

    private func updateUI(item: Item) {
        titleLabel.text = "\(item.television.name)"
        countLabel.text = "\(item.count)"
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground

        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(controls)

        controls.addArrangedSubview(plusButton)
        controls.addArrangedSubview(countLabel)
        controls.addArrangedSubview(minusButton)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 300),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            controls.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            controls.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            controls.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}
