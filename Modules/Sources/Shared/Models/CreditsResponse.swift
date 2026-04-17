//
//  CreditsResponse.swift
//  Modules
//
//  Created by Michael Long on 4/17/26.
//

import Foundation

public struct CreditsResponse: Decodable, Equatable, Sendable {
    public let cast: [Cast]
    public let crew: [Crew]
}
