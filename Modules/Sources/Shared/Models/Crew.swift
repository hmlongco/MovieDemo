//
//  Crew.swift
//  Modules
//
//  Created by Michael Long on 4/17/26.
//

import Foundation

public struct Crew: Decodable, Identifiable, Equatable, Sendable {
    public let id: Int
    public let name: String
    public let job: String
    public let department: String
    public let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case job
        case department
        case profilePath = "profile_path"
    }

    public var profileURL: URL? {
        guard let path = profilePath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w185\(path)")
    }
}

#if DEBUG
public extension Crew {
    static var mock1: Crew {
        Crew(
            id: 525, name: "Christopher Nolan", job: "Director",
            department: "Directing", profilePath: "/xuAIuYSmsUzKlUMBFGVZaWsY3Zb.jpg"
        )
    }
    static var mock2: Crew {
        Crew(
            id: 525, name: "Christopher Nolan", job: "Director",
            department: "Directing", profilePath: "/xuAIuYSmsUzKlUMBFGVZaWsY3Zb.jpg"
        )
    }
}
#endif
