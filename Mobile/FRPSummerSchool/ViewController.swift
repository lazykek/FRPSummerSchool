//
//  ViewController.swift
//  FRPSummerSchool
//
//  Created by Ilia Cherkasov on 16.06.2024.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {

    // MARK: - UI

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = .init(width: 200, height: 200)
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: flowLayout
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    // MARK: - Properties

    private var items: [Item] = []
    private let storage = Storage.shared
    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        storage.items
            .observe(on: MainScheduler.instance)
            .subscribe(
            onNext: { [weak self] items in
                self?.items = items
                self?.collectionView.reloadData()
            },
            onError: { error in
                print(error)
            }
        )
        .disposed(by: disposeBag)
    }

    // MARK: - Private methods

    private func setupUI() {
        title = "Телевизоры"
        navigationItem.rightBarButtonItem = .init(
            systemItem: .edit,
            primaryAction: .init(handler: { _ in })
        )

        view.backgroundColor = .systemBackground
        view.addSubview(stackView)
        stackView.addArrangedSubview(collectionView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])

        collectionView.contentInset = .init(top: 16, left: 16, bottom: 16, right: 16)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(
            ItemCell.self,
            forCellWithReuseIdentifier: "ItemCell"
        )

        Storage.shared.items
            .bind(
                to: collectionView.rx.items(cellIdentifier: "ItemCell")
            ) { index, item, cell in
                let cell = cell as? ItemCell
                cell?.item = item
            }
            .disposed(by: disposeBag)

        collectionView
            .rx
            .itemSelected
            .flatMap { [unowned self] indexPath in
                self.storage.items
                    .take(1)
                    .map { items in
                        items[indexPath.row]
                    }
            }
            .observe(on: MainScheduler.instance)
            .bind { [unowned self] item in
                openDetails(item: item)
            }
            .disposed(by: disposeBag)
    }

    private func openDetails(item: Item) {
        let vc = DetailsViewController()
        vc.item = item
        self.navigationController?.pushViewController(
            vc,
            animated: true
        )
    }
}
