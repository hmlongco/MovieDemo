//
//  MovieResponse.swift
//  Modules
//
//  Created by Michael Long on 4/17/26.
//

import Foundation

public struct MovieResponse: Decodable, Equatable, Sendable {
    public let page: Int
    public let results: [Movie]
    public let totalPages: Int
    public let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

#if DEBUG
public extension MovieResponse {
    static var mock: MovieResponse {
        MovieResponse(
            page: 1,
            results: [.mock1, .mock2, .mock3, .mock4, .mock5, .mock6],
            totalPages: 10,
            totalResults: 200
        )
    }
}
#endif
