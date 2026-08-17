import Foundation

public struct PersonCombinedCredits: Decodable, Equatable, Sendable {
    public let cast: [PersonCredit]
    public let crew: [PersonCredit]
}

public struct PersonCredit: Decodable, Identifiable, Equatable, Sendable {
    public let creditId: String
    public let id: Int
    public let mediaType: String
    public let title: String?
    public let name: String?
    public let posterPath: String?
    public let releaseDate: String?
    public let firstAirDate: String?
    public let character: String?
    public let job: String?

    enum CodingKeys: String, CodingKey {
        case creditId = "credit_id"
        case id
        case mediaType = "media_type"
        case title
        case name
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case firstAirDate = "first_air_date"
        case character
        case job
    }

    public var identity: String { creditId }
    public var displayTitle: String { title ?? name ?? "" }
    public var displayDate: String? { releaseDate ?? firstAirDate }
    public var roleText: String { character ?? job ?? "" }

    public var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w185\(path)")
    }
}

#if DEBUG
public extension PersonCredit {
    static var mock1: PersonCredit {
        PersonCredit(
            creditId: "52fe4292c3a36847f802916d", id: 27205, mediaType: "movie",
            title: "Inception", name: nil, posterPath: "/9gk7adHYeDvHkCSEqAvQNLV5Uge.jpg",
            releaseDate: "2010-07-16", firstAirDate: nil, character: "Dom Cobb", job: nil
        )
    }
    static var mock2: PersonCredit {
        PersonCredit(
            creditId: "52fe4409c3a36847f80f4001", id: 1856, mediaType: "movie",
            title: "The Departed", name: nil, posterPath: "/dGi5OVeYo7BbFxaeci9haBcVhLK.jpg",
            releaseDate: "2006-10-06", firstAirDate: nil, character: "Billy Costigan", job: nil
        )
    }
    static var mock3: PersonCredit {
        PersonCredit(
            creditId: "52fe4409c3a36847f80f4007", id: 244786, mediaType: "movie",
            title: "Whiplash", name: nil, posterPath: "/6uSPcdGNA2A6vJmCagXkvnutegs.jpg",
            releaseDate: "2014-10-10", firstAirDate: nil, character: nil, job: "Executive Producer"
        )
    }
}

public extension PersonCombinedCredits {
    static var mock1: PersonCombinedCredits {
        PersonCombinedCredits(cast: [.mock1, .mock2], crew: [.mock3])
    }
}
#endif
