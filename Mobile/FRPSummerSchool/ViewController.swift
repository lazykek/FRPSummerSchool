//
//  ViewController.swift
//  FRPSummerSchool
//
//  Created by Ilia Cherkasov on 16.06.2024.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Private properties

    private var items: [Item] = []
    private let storage = Storage.shared

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

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        collectionView.delegate = self
        collectionView.dataSource = self
        storage.onCartItems = { [weak self] items in
            //TODO: - неправильный код, могут быть ошибки с многопоточностью
            self?.items = items
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }

    // MARK: - Private methods

    private func setupUI() {
        title = "Телевизоры"

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
        let vc = DetailsViewController(id: item.television.id)
        self.navigationController?.pushViewController(
            vc,
            animated: true
        )
    }

    private func openFilters() {
        let vc = FiltersViewController(price: 0)
        self.navigationController?.present(vc, animated: true)
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        items.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ItemCell.id,
            for: indexPath
        ) as? ItemCell
        cell?.item = items[indexPath.row]
        return cell ?? UICollectionViewCell()
    }
}

extension ViewController: UICollectionViewDelegate {

}
