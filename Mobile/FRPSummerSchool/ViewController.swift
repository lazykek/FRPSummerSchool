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

    // MARK: - Properties

    private let storage = Storage.shared
    private let minPriceSubject = BehaviorSubject<Int>(value: 0)
    private let disposeBag = DisposeBag()
    private var filtersDisposeBag = DisposeBag()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    
        Observable.combineLatest(
            storage.items,
            minPriceSubject
        )
        .compactMap { items, minPrice in
            items
                .filter { $0.stock.price >= minPrice }
        }
        .distinctUntilChanged()
        .bind(
            to: collectionView.rx.items(cellIdentifier: ItemCell.id)
        ) { index, item, cell in
            let cell = cell as? ItemCell
            cell?.item = item
            cell?.onAdding = { [unowned self] id in
                storage.addItem(id: id)
            }
            cell?.onRemoving = { [unowned self] id in
                storage.removeItem(id: id)
            }
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
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 550),
        ])

        collectionView.contentInset = .init(top: 16, left: 16, bottom: 16, right: 16)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(
            ItemCell.self,
            forCellWithReuseIdentifier: ItemCell.id
        )
    }

    private func openDetails(item: Item) {
        let vc = DetailsViewController(id: item.stock.id)
        self.navigationController?.pushViewController(
            vc,
            animated: true
        )
    }

    private func openFilters() {
        let vc = FiltersViewController(price: (try? minPriceSubject.value()) ?? 0)
//        luggy code
//        vc.price.subscribe(minPriceSubject)
//            .disposed(by: filtersDisposeBag)
//        completed эммитится в общий флоу,
//        и поэтому даже после пересоздания подписки
//        таблица не обновляется
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
