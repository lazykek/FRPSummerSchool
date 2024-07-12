//
//  FiltersViewController.swift
//  FRPSummerSchool
//
//  Created by Ilia Cherkasov on 18.06.2024.
//

import UIKit
import RxSwift

final class FiltersViewController: UIViewController {

    // MARK: - Internal properties

    var price: Observable<Int> {
        slider.rx.value
            .map { Int($0) }
            .asObservable()
    }

    // MARK: - Private properties

    private let disposeBag = DisposeBag()

    // MARK: - UI

    private let slider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 50_000
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }

    // MARK: - Lifecycle

    init(price: Int) {
        super.init(nibName: nil, bundle: nil)

        slider.value = Float(price)
        slider.rx.value
            .asDriver()
            .map { Int($0).description }
            .drive(priceLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods

    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(slider)
        view.addSubview(priceLabel)
        NSLayoutConstraint.activate([
            slider.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            slider.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            slider.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            slider.heightAnchor.constraint(equalToConstant: 30),

            priceLabel.topAnchor.constraint(equalTo: slider.safeAreaLayoutGuide.bottomAnchor, constant: 16),
            priceLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            priceLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
}
