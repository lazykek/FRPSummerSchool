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

    private let cartView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.opacity = 0.0
        view.backgroundColor = .blue
        return view
    }()

    // MARK: - Properties

    private let storage = Storage.shared
    private let minPriceSubject = BehaviorSubject<Int>(value: 0)
    private let disposeBag = DisposeBag()
    private var cellsDisposeBag = DisposeBag()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        Observable.combineLatest(
            storage.items,
            minPriceSubject,
            searchBar.rx.text
                .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
                .compactMap { $0?.uppercased() }
        )
        .compactMap { items, minPrice, searchText in
            items
                .filter { $0.stock.price >= minPrice }
                .filter {
                    !searchText.isEmpty ? $0.stock.name.uppercased().contains(searchText) : true
                }
        }
        .do(onNext: { [unowned self] _ in
            cellsDisposeBag = DisposeBag()
        })
        .bind(
            to: collectionView.rx.items(cellIdentifier: ItemCell.id)
        ) { [unowned self] index, item, cell in
            let cell = cell as? ItemCell
            cell?.item = item
            cell?.plusTap
                .drive(onNext: storage.addItem(id:))
                .disposed(by: cellsDisposeBag)
            cell?.minusTap
                .drive(onNext: storage.removeItem(id:))
                .disposed(by: cellsDisposeBag)
        }
        .disposed(by: disposeBag)

        collectionView.rx.itemSelected
            .flatMap { [unowned self] indexPath in
                self.storage.items
                    .take(1)
                    .map { items in
                        items[indexPath.row]
                    }
            }
            .bind { [unowned self] item in
                openDetails(item: item)
            }
            .disposed(by: disposeBag)

        let barItem = UIBarButtonItem(systemItem: .edit)
        barItem.rx.tap.bind { [unowned self] _ in
            openFilters()
        }
        .disposed(by: disposeBag)
        navigationItem.rightBarButtonItem = barItem
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
        let vc = FiltersViewController(price: (try? minPriceSubject.value()) ?? 0)
        vc.price.subscribe { [unowned self] value in
            minPriceSubject.onNext(value)
        }
        .disposed(by: disposeBag)

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
