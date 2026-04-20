//
//  SharedDependencies.swift
//  Modules
//
//  Created by Michael Long on 4/19/26.
//

import Foundation

public protocol SharedDependencies: DependencyContainer
    & Networking
{}

extension SharedDependencies {
    @MainActor
    public var movieService: MovieServices {
        singleton {
            MovieService(client: self.networkClient)
        }
    }

    @MainActor
    public var movieRepository: MovieServices {
        singleton {
            MovieRepository(service: self.movieService)
        }
    }
}
