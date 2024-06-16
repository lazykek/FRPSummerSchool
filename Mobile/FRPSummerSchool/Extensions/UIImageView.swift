//
//  UIImageView.swift
//  FRPSummerSchool
//
//  Created by Ilia Cherkasov on 16.06.2024.
//

import UIKit

extension UIImageView {
    func load(url: URL) {
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil, let data else {
                return
            }
            DispatchQueue.main.async { [weak self] in
                self?.image = UIImage(data: data)
            }
        }
        .resume()
    }
}
