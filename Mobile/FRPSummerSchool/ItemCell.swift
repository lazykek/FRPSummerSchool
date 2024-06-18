//
//  ItemCell.swift
//  FRPSummerSchool
//
//  Created by Ilia Cherkasov on 16.06.2024.
//

import UIKit

final class ItemCell: UICollectionViewCell {

    // MARK: - Properties

    static let id = "ItemCellId"
    var item: Item? {
        didSet {
            updateUI()
        }
    }
    var onAdding: ((String) -> Void)?
    var onRemoving: ((String) -> Void)?

    // MARK: - UI

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .lightGray
        return imageView
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
        contentView.addSubview(imageView)
        contentView.addSubview(controls)

        controls.addArrangedSubview(plusButton)
        controls.addArrangedSubview(countLabel)
        controls.addArrangedSubview(minusButton)

        layer.cornerRadius = 10
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor

        plusButton.addAction(
            .init(handler: { [weak self] _ in
                self?.onAdding?(self?.item?.television.id ?? "")
            }),
            for: .touchUpInside
        )

        minusButton.addAction(
            .init(handler: { [weak self] _ in
                self?.onRemoving?(self?.item?.television.id ?? "")
            }),
            for: .touchUpInside
        )

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 150),
        
            controls.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            controls.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            controls.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            controls.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        item = nil
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private properties

    private func updateUI() {
        guard let item else {
            imageView.image = nil
            countLabel.text = nil
            return
        }
        imageView.load(url: URL(string: item.television.url)!)
        countLabel.text = "\(item.count)"
    }
}
