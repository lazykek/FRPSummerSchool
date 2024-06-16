//
//  File.swift
//  
//
//  Created by Ilia Cherkasov on 16.06.2024.
//

import Vapor

struct Item: Encodable {
  let name: String
  let price: Int
  let id: String
  let url: String
}
