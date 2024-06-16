import Vapor

// MARK: - Global

@MainActor
var timeout: Duration = .milliseconds(200)

// MARK: - Rotes

func routes(_ app: Application) throws {
    app.get("items") { req async -> String in
        try? await Task.sleep(for: timeout)
        return [
          Item(name: "Винтаж", price: 20_000, url: "https://www.google.com/url?sa=i&url=https%3A%2F%2Fmuseum.vyatsu.ru%2Fexposure%2F%25D1%2581%25D0%25BE%25D0%25B2%25D0%25B5%25D1%2582%25D1%2581%25D0%25BA%25D0%25B8%25D0%25B5-%25D1%2582%25D0%25B5%25D0%25BB%25D0%25B5%25D0%25B2%25D0%25B8%25D0%25B7%25D0%25BE%25D1%2580%25D1%258B-1949-1989%2F&psig=AOvVaw1N848HTmO04iBlE8aUirqM&ust=1718624913286000&source=images&cd=vfe&opi=89978449&ved=0CBEQjRxqFwoTCNCVvO2G4IYDFQAAAAAdAAAAABAd"),
          Item(name: "Sony", price: 10_000, url: "https://www.google.com/url?sa=i&url=https%3A%2F%2Fpikabu.ru%2Fstory%2Flegendarnyiy_televizor_90kh_7684007&psig=AOvVaw1N848HTmO04iBlE8aUirqM&ust=1718624913286000&source=images&cd=vfe&opi=89978449&ved=0CBEQjRxqFwoTCNCVvO2G4IYDFQAAAAAdAAAAABBO"),
          Item(name: "Юность", price: 15_000, url: "https://www.google.com/url?sa=i&url=https%3A%2F%2Fbruhovetskaya.bezformata.com%2Flistnews%2Fkuban-24-menyaet-starie-televizori%2F74864601%2F&psig=AOvVaw1N848HTmO04iBlE8aUirqM&ust=1718624913286000&source=images&cd=vfe&opi=89978449&ved=0CBEQjRxqFwoTCNCVvO2G4IYDFQAAAAAdAAAAABBY"),
          Item(name: "Кубань", price: 5_000, url: "https://www.google.com/url?sa=i&url=https%3A%2F%2Fmuseum.vyatsu.ru%2Fexposure%2F%25D1%2581%25D0%25BE%25D0%25B2%25D0%25B5%25D1%2582%25D1%2581%25D0%25BA%25D0%25B8%25D0%25B5-%25D1%2582%25D0%25B5%25D0%25BB%25D0%25B5%25D0%25B2%25D0%25B8%25D0%25B7%25D0%25BE%25D1%2580%25D1%258B-1949-1989%2F&psig=AOvVaw1N848HTmO04iBlE8aUirqM&ust=1718624913286000&source=images&cd=vfe&opi=89978449&ved=0CBEQjRxqFwoTCNCVvO2G4IYDFQAAAAAdAAAAABBi")
        ].toJson
    }
}
