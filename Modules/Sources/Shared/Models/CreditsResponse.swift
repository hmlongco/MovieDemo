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

#if DEBUG
public extension CreditsResponse {
    static var mock: CreditsResponse {
        CreditsResponse(
            cast: [.mock1, .mock2, .mock3, .mock4, .mock5, .mock6],
            crew: [.mock1, .mock2]
        )
    }
}
#endif
