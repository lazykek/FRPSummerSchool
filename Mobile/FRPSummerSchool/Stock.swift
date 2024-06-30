//
//  Stock.swift
//  FRPSummerSchool
//
//  Created by Ilia Cherkasov on 16.06.2024.
//

import UIKit

struct Stock: Decodable, Equatable {
    let name: String
    let price: Int
    let color: UIColor
    let id: String

    enum CodingKeys: String, CodingKey {
        case name
        case price
        case color
        case id
    }

    struct ColorDTO: Decodable {
        let r: CGFloat
        let g: CGFloat
        let b: CGFloat
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.price = try container.decode(Int.self, forKey: .price)
        let color = try container.decode(ColorDTO.self, forKey: .color)
        self.color = UIColor(
            red: color.r,
            green: color.g,
            blue: color.b,
            alpha: 1
        )
        self.id = try container.decode(String.self, forKey: .id)
    }
}
