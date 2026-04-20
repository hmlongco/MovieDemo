//
//  Networking.swift
//  Modules
//
//  Created by Michael Long on 4/19/26.
//

import Foundation

public protocol Networking: DependencyContainer {
    var apiKey: String { get } // must be resolved by container
}

public extension Networking {
    var networkClient: NetworkClient {
        singleton {
            NetworkClient(
                configuration: NetworkConfiguration(baseURL: TMDBConfiguration.baseURL),
                interceptors: [
                    TMDBRequestInterceptor(apiKey: self.apiKey),
                    LoggerInterceptor()
                ]
            )
        }
    }
}
