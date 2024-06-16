import Vapor

// MARK: - Global

@MainActor
var timeout: Duration = .milliseconds(200)

// MARK: - Rotes

func routes(_ app: Application) throws {
    app.get("items") { req async -> String in
        try? await Task.sleep(for: timeout)
        return [Item(name: "tv", price: 20_000)].toJson
    }
}
