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
        // WARNING: Add your own TMDB Authorization API key
        movieApiKey.register { "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJhNjE0NzAzYjhjNTYxNmM5MDEzNmU2YWU4NTRjYzU5MyIsIm5iZiI6MTc3NjcxMjE1Mi43OTYsInN1YiI6IjY5ZTY3OWQ4NjQzYjdlYmUwZjA2NDYxMSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.2urBrtjWlhX-IaDT6aySvTWwEmHjbIsk36jfA8-TkIQ"
        }
    }
}
