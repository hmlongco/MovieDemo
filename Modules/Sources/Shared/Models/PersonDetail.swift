import Foundation

public struct PersonDetail: Decodable, Identifiable, Equatable, Sendable {
    public let id: Int
    public let name: String
    public let biography: String
    public let birthday: String?
    public let deathday: String?
    public let placeOfBirth: String?
    public let knownForDepartment: String?
    public let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case biography
        case birthday
        case deathday
        case placeOfBirth = "place_of_birth"
        case knownForDepartment = "known_for_department"
        case profilePath = "profile_path"
    }

    public var profileURL: URL? {
        guard let path = profilePath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w300\(path)")
    }
}

public extension PersonDetail {
    static var mock1: PersonDetail {
        PersonDetail(
            id: 6193,
            name: "Leonardo DiCaprio",
            biography: "Leonardo Wilhelm DiCaprio is an American actor and film producer "
                + "known for his work in biopics and period films.",
            birthday: "1974-11-11",
            deathday: nil,
            placeOfBirth: "Los Angeles, California, USA",
            knownForDepartment: "Acting",
            profilePath: "/wo2hJpn04vbtmh0B9utCFdsQhxM.jpg"
        )
    }
}
