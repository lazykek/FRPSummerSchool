import Vapor

// MARK: - Global

@MainActor
var timeout: Duration = .milliseconds(200)

// MARK: - Rotes

func routes(_ app: Application) throws {
    app.get("items") { req async -> String in
        try? await Task.sleep(for: timeout)
        return [
          Item(
            name: "Винтаж",
            price: 20_000, 
            id: "496f2347-5943-44ec-ac87-8c04e00f01fb",
            url: "https://museum.vyatsu.ru/wp-content/uploads/2017/05/t_1.jpg"
          ),
          Item(
            name: "Sony",
            price: 10_000, 
            id: "58e1fc66-8f53-4044-97e1-c60f6c4396a8",
            url: "https://museum.vyatsu.ru/wp-content/uploads/2017/05/t_2.jpg"
          ),
          Item(
            name: "Юность",
            price: 15_000,
            id: "5b373aea-593f-4339-9c3e-09d3ae7d25ef",
            url: "https://museum.vyatsu.ru/wp-content/uploads/2017/05/t_3.jpg"
          ),
          Item(
            name: "Кубань",
            price: 5_000, 
            id: "64161245-ee2d-4679-8fd1-bbbe1c6a40a8",
            url: "https://museum.vyatsu.ru/wp-content/uploads/2017/05/t_4.jpg"
          ),
          Item(
            name: "Космос",
            price: 800_000,
            id: "298e490e-386b-407a-8361-fcd2e2f681bc",
            url: "https://museum.vyatsu.ru/wp-content/uploads/2017/05/t_5.jpg"
          ),
          Item(
            name: "Владивосток",
            price: 245_000,
            id: "c239bda9-bc71-4cbf-a11a-6499c0f7715e",
            url: "https://museum.vyatsu.ru/wp-content/uploads/2017/05/t_6.jpg"
          )
        ].toJson
    }
}
