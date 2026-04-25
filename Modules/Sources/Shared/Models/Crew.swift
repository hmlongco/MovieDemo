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
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case job
        case department
    }
}

#if DEBUG
public extension Crew {
    static var mock1: Crew {
        Crew(id: 525, name: "Christopher Nolan", job: "Director", department: "Directing")
    }
    static var mock2: Crew {
        Crew(id: 525, name: "Christopher Nolan", job: "Director", department: "Directing")
    }
}
#endif
