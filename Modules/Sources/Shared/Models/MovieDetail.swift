import Foundation

public struct MovieDetail: Decodable, Identifiable, Equatable, Sendable {
    public let id: Int
    public let title: String
    public let overview: String
    public let releaseDate: String?
    public let posterPath: String?
    public let backdropPath: String?
    public let voteAverage: Double
    
    // Extended properties
    public let runtime: Int?
    public let genres: [Genre]?
    public let credits: CreditsResponse?
    public let similar: MovieResponse?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case voteAverage = "vote_average"
        case runtime
        case genres
        case credits
        case similar
    }
    
    public var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
    
    public var backdropURL: URL? {
        guard let path = backdropPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w780\(path)")
    }
    
    // Formatting helpers
    public var durationText: String {
        guard let runtime = runtime, runtime > 0 else { return "" }
        let hours = runtime / 60
        let minutes = runtime % 60
        return "\(hours)h \(minutes)m"
    }
    
    public var genreText: String {
        genres?.prefix(2).map { $0.name }.joined(separator: ", ") ?? ""
    }
    
    public var director: Crew? {
        credits?.crew.first(where: { $0.job == "Director" })
    }
}

#if DEBUG
public extension MovieDetail {
    static var mock: MovieDetail {
        MovieDetail(id: 27205, title: "Inception", overview: "A thief who steals corporate secrets through dream-sharing technology is given the inverse task of planting an idea into the mind of a C.E.O.", releaseDate: "2010-07-16", posterPath: "/9gk7adHYeDvHkCSEqAvQNLV5Uge.jpg", backdropPath: "/s3TBrRGB1iav7gFOCNx3H31MoES.jpg", voteAverage: 8.4, runtime: 148, genres: [Genre(id: 28, name: "Action"), Genre(id: 878, name: "Science Fiction"), Genre(id: 12, name: "Adventure")], credits: .mock, similar: .mock)
    }
    static var mock1: MovieDetail {
        MovieDetail(id: 155, title: "The Dark Knight", overview: "Batman raises the stakes in his war on crime by pursuing the mysterious Joker, a criminal mastermind who plunges Gotham City into anarchy.", releaseDate: "2008-07-18", posterPath: "/qJ2tW6WMUDux911r6m7haRef0WH.jpg", backdropPath: "/hqkIcbrOHL86UncnHIsHVcVmzue.jpg", voteAverage: 9.0, runtime: 152, genres: [Genre(id: 28, name: "Action"), Genre(id: 80, name: "Crime"), Genre(id: 18, name: "Drama")], credits: .mock, similar: .mock)
    }
    static var mock2: MovieDetail {
        MovieDetail(id: 157336, title: "Interstellar", overview: "A team of explorers travel through a wormhole in space in an attempt to ensure humanity's survival.", releaseDate: "2014-11-05", posterPath: "/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg", backdropPath: "/xJHokMbljvjADYdit5fK5VQsXEG.jpg", voteAverage: 8.6, runtime: 169, genres: [Genre(id: 878, name: "Science Fiction"), Genre(id: 12, name: "Adventure"), Genre(id: 18, name: "Drama")], credits: .mock, similar: .mock)
    }
    static var mock3: MovieDetail {
        MovieDetail(id: 603, title: "The Matrix", overview: "A computer hacker learns from mysterious rebels about the true nature of his reality and his role in the war against its controllers.", releaseDate: "1999-03-31", posterPath: "/f89U3ADr1oiB1s9GkdPOEpXUk5H.jpg", backdropPath: "/fNG7i7RqMErkcqhohV2a6cV1Ehy.jpg", voteAverage: 8.2, runtime: 136, genres: [Genre(id: 28, name: "Action"), Genre(id: 878, name: "Science Fiction")], credits: .mock, similar: .mock)
    }
    static var mock4: MovieDetail {
        MovieDetail(id: 438631, title: "Dune", overview: "A noble family becomes embroiled in a war for control over the galaxy's most valuable asset while its heir becomes troubled by visions of a dark future.", releaseDate: "2021-09-15", posterPath: "/d5NXSklpcvkmXBD8zLPB4nC5NBBA.jpg", backdropPath: "/jYEW5xZkZk2WTrdbMGAPFuBqbDc.jpg", voteAverage: 7.8, runtime: 155, genres: [Genre(id: 878, name: "Science Fiction"), Genre(id: 12, name: "Adventure")], credits: .mock, similar: .mock)
    }
    static var mock5: MovieDetail {
        MovieDetail(id: 872585, title: "Oppenheimer", overview: "The story of J. Robert Oppenheimer's role in the development of the atomic bomb during World War II.", releaseDate: "2023-07-19", posterPath: "/8Gxv8giaFIzmZTToSIiwEksSIn5.jpg", backdropPath: "/rLb2cwF3Pazuxaj0sRXQ037tGI1.jpg", voteAverage: 8.2, runtime: 180, genres: [Genre(id: 18, name: "Drama"), Genre(id: 36, name: "History")], credits: .mock, similar: .mock)
    }
    static var mock6: MovieDetail {
        MovieDetail(id: 329865, title: "Arrival", overview: "A linguist works with the military to communicate with alien lifeforms after twelve mysterious spacecraft appear around the world.", releaseDate: "2016-11-11", posterPath: "/x2FJsf1ElAgr63Y3PNPtJrcmpoe.jpg", backdropPath: "/vuza0WqY239yBXOadKlGwJsZJFE.jpg", voteAverage: 7.9, runtime: 116, genres: [Genre(id: 878, name: "Science Fiction"), Genre(id: 18, name: "Drama"), Genre(id: 9648, name: "Mystery")], credits: .mock, similar: .mock)
    }
}
#endif
