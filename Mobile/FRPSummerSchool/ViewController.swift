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

    private let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.placeholder = "Поиск"
        return bar
    }()

    private let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = .init(width: 200, height: 250)
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: flowLayout
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private let cartView: CartView = {
        let view = CartView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.opacity = 0.0
        view.backgroundColor = .blue.withAlphaComponent(0.3)
        return view
    }()

    // MARK: - Properties

    private let storage = Storage.shared
    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        storage.items
            .bind(
                to: collectionView.rx.items(cellIdentifier: ItemCell.id, cellType: ItemCell.self)
            ) { index, item, cell in
                cell.item = item
            }
            .disposed(by: disposeBag)
        
        let visibleCell = collectionView.rx.willDisplayCell
            .asDriver()
            .compactMap { cell, id in
                cell as? ItemCell
            }

        visibleCell
            .flatMap { cell in
                cell.plusTap
            }
            .drive(onNext: storage.addItem(id:))
            .disposed(by: disposeBag)

        visibleCell
            .flatMap { cell in
                cell.minusTap
            }
            .drive(onNext: storage.removeItem(id:))
            .disposed(by: disposeBag)

        collectionView
            .rx
            .itemSelected
            .compactMap { [unowned self] indexPath in
                (collectionView.cellForItem(at: indexPath) as? ItemCell)?.item
            }
            .observe(on: MainScheduler.instance)
            .bind { [unowned self] item in
                openDetails(item: item)
            }
            .disposed(by: disposeBag)
    }

    // MARK: - Private methods

    private func setupUI() {
        title = "Акции"

        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        view.addSubview(cartView)
        view.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 550),

            cartView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            cartView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            cartView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cartView.heightAnchor.constraint(equalToConstant: 150)
        ])

        collectionView.contentInset = .init(top: 16, left: 16, bottom: 16, right: 16)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(
            ItemCell.self,
            forCellWithReuseIdentifier: ItemCell.id
        )
    }

    private func openDetails(item: CartItem) {
        let vc = DetailsViewController(id: item.stock.id)
        self.navigationController?.pushViewController(
            vc,
            animated: true
        )
    }

    private func openFilters() {
        let vc = FiltersViewController(price: 0)

        vc.modalPresentationStyle = .pageSheet
        vc.sheetPresentationController?.detents = [
            .custom(
                resolver: { context in
                    150
                }
            )
        ]
        self.navigationController?.present(vc, animated: true)
    }
}
