//
//  AppDependencies.swift
//  Modules
//
//  Created by Michael Long on 4/20/26.
//

import FactoryKit
import Shared

extension Container: AutoRegistering {
    public func autoRegister() {
        // WARNING: Add your own TMDB API key
        movieApiKey.register { "a614703b8c5616c90136e6ae854cc593" }
    }
}
