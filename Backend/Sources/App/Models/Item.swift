//
//  File.swift
//  
//
//  Created by Ilia Cherkasov on 16.06.2024.
//

import Vapor

struct Item: Encodable {
    let name: String
    var price: Int
    let color = Color()
    let id: String = UUID().uuidString
}

struct Color: Encodable {
    let r: CGFloat = .random(in: 0...1)
    let g: CGFloat = .random(in: 0...1)
    let b: CGFloat = .random(in: 0...1)
}
