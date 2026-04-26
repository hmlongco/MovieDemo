import Foundation

public struct Genre: Codable, Identifiable, Equatable, Hashable, Sendable {
    public let id: Int
    public let name: String
    
    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    static var placeholder: Genre {
        .init(id: -1, name: "Genre")
    }
}

public struct GenreResponse: Codable, Equatable, Sendable {
    public let genres: [Genre]
}

#if DEBUG
public extension Genre {
    static var mock: Genre {
        Genre(id: 28, name: "Action")
    }
}

public extension GenreResponse {
    static var mock1: GenreResponse {
        GenreResponse(genres: [
            Genre(id: 28, name: "Action"),
            Genre(id: 878, name: "Science Fiction"),
            Genre(id: 12, name: "Adventure"),
            Genre(id: 18, name: "Drama"),
            Genre(id: 53, name: "Thriller")
        ])
    }
}
#endif
