//
//  ItemCell.swift
//  FRPSummerSchool
//
//  Created by Ilia Cherkasov on 16.06.2024.
//

import UIKit
import RxCocoa
import RxSwift

final class ItemCell: UICollectionViewCell {

    // MARK: - Public properties

    static let id = "ItemCellId"
    var item: CartItem? {
        didSet {
            updateUI()
        }
    }
    var plusTap: Signal<String> {
        plusTapSubject.asSignal(onErrorJustReturn: "")
    }

    var minusTap: Signal<String> {
        minusTapSubject.asSignal(onErrorJustReturn: "")
    }

    // MARK: - Private properties

    private var plusTapSubject: PublishSubject<String> = .init()
    private var minusTapSubject: PublishSubject<String> = .init()
    private var disposeBag = DisposeBag()

    // MARK: - UI

    private let colorView: UIView = {
        let colorView = UIImageView()
        colorView.translatesAutoresizingMaskIntoConstraints = false
        return colorView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
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
        button.titleLabel?.font = .boldSystemFont(ofSize: 30)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let minusButton: UIButton = {
        let button = UIButton()
        button.setTitle(" - ", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 30)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        resubcribe()
        setupUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        resubcribe()
        updateUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private properties

    private func resubcribe() {
        plusTapSubject.onCompleted()
        minusTapSubject.onCompleted()
        plusTapSubject = .init()
        minusTapSubject = .init()
        disposeBag = DisposeBag()
        plusButton.rx.tap
            .map { _ in self.item?.stock.id ?? "" }
            .subscribe(plusTapSubject)
            .disposed(by: disposeBag)
        minusButton.rx.tap
            .map { _ in self.item?.stock.id ?? "" }
            .subscribe(minusTapSubject)
            .disposed(by: disposeBag)
    }

    private func updateUI() {
        guard let item else {
            colorView.backgroundColor = .clear
            nameLabel.text = nil
            priceLabel.text = nil
            countLabel.text = nil
            return
        }
        colorView.backgroundColor = item.stock.color
        nameLabel.text = item.stock.name
        priceLabel.text = "\(item.stock.price) у.е."
        countLabel.text = "\(item.count)"
    }

    private func setupUI() {
        contentView.addSubview(colorView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(controls)

        controls.addArrangedSubview(plusButton)
        controls.addArrangedSubview(countLabel)
        controls.addArrangedSubview(minusButton)

        layer.cornerRadius = 10
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor

        NSLayoutConstraint.activate([
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            colorView.heightAnchor.constraint(equalToConstant: 150),

            nameLabel.topAnchor.constraint(equalTo: colorView.bottomAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),

            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),

            controls.topAnchor.constraint(equalTo: priceLabel.bottomAnchor),
            controls.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            controls.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            controls.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}
