import Vapor

// MARK: - Global

@MainActor var timeout: Duration = .milliseconds(200 + .random(in: 0...100))
@MainActor var items: [Item] = {
  names.map { name in
    Item(name: name, price: Int.random(in: 100...50_000))
  }
}()

// MARK: - Rotes

func routes(_ app: Application) throws {
  app.get("items") { req async -> String in
    try? await Task.sleep(for: timeout)
    let searchText = req.query[String.self, at: "search_text"] ?? ""
    return await items
      .update()
      .filter {
        !searchText.isEmpty ? $0.name.lowercased().contains(searchText.lowercased()) : true
      }
      .toJson
  }
}

let names = [
  "Альтима", "Вектор-М", "Галактика", "Дельта-Бета", "Инфинити", "Квадро", "Лайт-Про", "Мега-Плюс", "Омега-Лайт", "Перспектива", "Прогресс-Джет", "Рекорд", "Сириус-Альфа", "Сплав-М", "Стратегия", "Техно-Плюс", "Транс-Лайт", "Ультиматум", "Феникс-Вектор", "Фортуна", "Эверест-Плюс", "Энерго-М", "Юпитер", "Альфа-Гамма", "Бета-Дельта", "Гелиос-Лайт", "Динамика", "Импульс", "Компас", "Кондор", "Кристалл", "Лидер", "Максимум", "Мираж", "Навигатор", "Ника", "Новатор", "Оптима", "Орбита", "Парус", "Пирамида", "Пламя", "Полюс", "Прометей", "Радиус", "Резерв", "Ритм", "Сатурн", "Старт", "Тандем"
]

extension Array where Element == Item {
  func update() -> Self {
    self.map { item in
      var item = item
      item.price += .random(in: -100...100)
      item.price = Swift.max(item.price, 100)
      return item
    }
  }
}
