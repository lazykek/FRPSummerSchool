//
//  Encodable.swift
//
//
//  Created by Ilia Cherkasov on 16.06.2024.
//

import Foundation

extension Encodable {
  var toJson: String {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    guard
      let encoded = try? encoder.encode(self),
      let json = String(data: encoded, encoding: .utf8)
    else {
      return ""
    }
    return json
  }
}
