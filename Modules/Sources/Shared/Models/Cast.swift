import Foundation

public struct Cast: Decodable, Identifiable, Equatable, Sendable {
    public let id: Int
    public let name: String
    public let character: String
    public let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case character
        case profilePath = "profile_path"
    }
    
    public var profileURL: URL? {
        guard let path = profilePath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w185\(path)")
    }
}

#if DEBUG
public extension Cast {
    static var mock1: Cast {
        Cast(id: 6193, name: "Leonardo DiCaprio", character: "Dom Cobb", profilePath: "/wo2hJpn04vbtmh0B9utCFdsQhxM.jpg")
    }
    static var mock2: Cast {
        Cast(id: 24045, name: "Joseph Gordon-Levitt", character: "Arthur", profilePath: "/zSuXCR6xCKILBHuWABSFLsT5Z37.jpg")
    }
    static var mock3: Cast {
        Cast(id: 2524, name: "Tom Hardy", character: "Eames", profilePath: "/d81K0RH8UX7tZj49tZaQhZ9ewH.jpg")
    }
    static var mock4: Cast {
        Cast(id: 3899, name: "Ken Watanabe", character: "Saito", profilePath: "/doGOJgMpSIbBpIhMfomFrTBdJgD.jpg")
    }
    static var mock5: Cast {
        Cast(id: 8293, name: "Marion Cotillard", character: "Mal", profilePath: "/hDnHdUuFMHJObZfOaFvdQ2hMEUV.jpg")
    }
    static var mock6: Cast {
        Cast(id: 2037, name: "Cillian Murphy", character: "Robert Fischer", profilePath: "/dm6V24NjjvjMiCtbMkc8Y2WPm2e.jpg")
    }
    static var mock7: Cast {
        Cast(id: 27578, name: "Elliot Page", character: "Ariadne", profilePath: "/eTddBNJfm5OdF9Rl0T9WCrCOdbc.jpg")
    }

}
#endif
