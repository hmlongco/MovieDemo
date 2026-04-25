import Foundation

public struct Movie: Codable, Identifiable, Equatable, Sendable {
    public let id: Int
    public let title: String
    public let overview: String
    public let releaseDate: String?
    public let posterPath: String?
    public let backdropPath: String?
    public let voteAverage: Double
    
    public let genreIds: [Int]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case voteAverage = "vote_average"
        case genreIds = "genre_ids"
    }
    
    public var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
    
    public var backdropURL: URL? {
        guard let path = backdropPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w780\(path)")
    }
    
    public static var placeholder: Movie {
        Movie(
            id: 0,
            title: "Loading Movie Title",
            overview: "Loading Description",
            releaseDate: "2024-01-01",
            posterPath: nil,
            backdropPath: nil,
            voteAverage: 0.0,
            genreIds: []
        )
    }
}

#if DEBUG
public extension Movie {
    static var mock1: Movie {
        Movie(id: 27205, title: "Inception", overview: "A thief who steals corporate secrets through dream-sharing technology is given the inverse task of planting an idea into the mind of a C.E.O.", releaseDate: "2010-07-16", posterPath: "/9gk7adHYeDvHkCSEqAvQNLV5Uge.jpg", backdropPath: "/s3TBrRGB1iav7gFOCNx3H31MoES.jpg", voteAverage: 8.4, genreIds: [28, 878, 12])
    }
    static var mock2: Movie {
        Movie(id: 157336, title: "Interstellar", overview: "A team of explorers travel through a wormhole in space in an attempt to ensure humanity's survival.", releaseDate: "2014-11-05", posterPath: "/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg", backdropPath: "/xJHokMbljvjADYdit5fK5VQsXEG.jpg", voteAverage: 8.6, genreIds: [878, 12, 18])
    }
    static var mock3: Movie {
        Movie(id: 603, title: "The Matrix", overview: "A computer hacker learns from mysterious rebels about the true nature of his reality and his role in the war against its controllers.", releaseDate: "1999-03-31", posterPath: "/f89U3ADr1oiB1s9GkdPOEpXUk5H.jpg", backdropPath: "/fNG7i7RqMErkcqhohV2a6cV1Ehy.jpg", voteAverage: 8.2, genreIds: [28, 878])
    }
    static var mock4: Movie {
        Movie(id: 438631, title: "Dune", overview: "A noble family becomes embroiled in a war for control over the galaxy's most valuable asset while its heir becomes troubled by visions of a dark future.", releaseDate: "2021-09-15", posterPath: "/d5NXSklpcvkmXBD8zLPB4nC5NBBA.jpg", backdropPath: "/jYEW5xZkZk2WTrdbMGAPFuBqbDc.jpg", voteAverage: 7.8, genreIds: [878, 12])
    }
    static var mock5: Movie {
        Movie(id: 872585, title: "Oppenheimer", overview: "The story of J. Robert Oppenheimer's role in the development of the atomic bomb during World War II.", releaseDate: "2023-07-19", posterPath: "/8Gxv8giaFIzmZTToSIiwEksSIn5.jpg", backdropPath: "/rLb2cwF3Pazuxaj0sRXQ037tGI1.jpg", voteAverage: 8.2, genreIds: [18, 36])
    }
    static var mock6: Movie {
        Movie(id: 329865, title: "Arrival", overview: "A linguist works with the military to communicate with alien lifeforms after twelve mysterious spacecraft appear around the world.", releaseDate: "2016-11-11", posterPath: "/x2FJsf1ElAgr63Y3PNPtJrcmpoe.jpg", backdropPath: "/vuza0WqY239yBXOadKlGwJsZJFE.jpg", voteAverage: 7.9, genreIds: [878, 18, 9648])
    }
}
#endif
