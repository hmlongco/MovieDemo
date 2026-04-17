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
