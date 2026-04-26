[![swift-versions](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fhmlongco%2FNavigator%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/hmlongco/Navigator)
[![platforms](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fhmlongco%2FNavigator%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/hmlongco/Navigator)
![License](https://img.shields.io/badge/License-MIT-brown.svg)

![](https://github.com/hmlongco/MovieDemo/blob/main/Logo.png?raw=true)

# MovieDemo

A SwiftUI movie browsing app powered by the [TMDB API](https://www.themoviedb.org/), built to demonstrate how to use [Factory](https://github.com/hmlongco/Factory) and [Navigator](https://github.com/hmlongco/Navigator) together in a modern, modular iOS application.

## Features

- Browse popular, top-rated, and now-playing movies
- Explore and filter movies by genre
- Search the full TMDB catalog
- View detailed movie information including cast, crew, and similar titles
- User profile with account settings

## Architecture

The application is split into two layers: a thin Xcode project that serves as the entry point, and a Swift Package that contains virtually all of the application code.

```
MovieDemo/
├── MovieDemo.xcodeproj     # App target — entry point only
├── Modules/                # Swift package — all application code
│   └── Package.swift
└── Playgrounds/            # Standalone preview apps
    ├── MoviesPlayground/
    └── ProfilePlayground/
```

### The Modules Package

All features, services, and UI live inside `Modules/`, a single SPM package that defines several libraries. This keeps the main app target minimal and makes each feature independently buildable and testable.

```
Modules/Sources/
├── App             # Root TabView, tab navigation, dependency bootstrap
├── Movies          # Home, Explore, Detail, Search, and List screens
├── Profile         # Profile view and account settings screens
├── Shared          # Models, networking client, services, common views
├── DesignSystem    # Shared UI components and styling utilities
├── MovieApp        # Slim re-export for the MoviesPlayground
└── ProfileApp      # Slim re-export for the ProfilePlayground
```

The main `MovieDemo` app target imports only the `App` library. Everything else is resolved transitively through the package graph.

### Dependency Injection — Factory

[Factory](https://github.com/hmlongco/Factory) is used throughout the app for dependency injection. All services are registered on `Container` via `AutoRegistering`, so dependencies are resolved automatically at startup with no manual wiring.

```swift
// Container+Extensions.swift
extension Container {
    var movieService: Factory<MovieServices> {
        self { MovieService(client: self.movieClient()) }.singleton
    }
}

// AppDependencies.swift
extension Container: AutoRegistering {
    public func autoRegister() {
        movieApiKey.register { "YOUR_TMDB_API_KEY" }
    }
}
```

In debug builds, `Container.setupMovieMocks()` replaces the network client with pre-recorded responses, so every SwiftUI Preview and unit test runs without hitting the network.

### Navigation — Navigator

[Navigator](https://github.com/hmlongco/Navigator) provides type-safe, declarative navigation via `ManagedNavigationStack`. Each tab owns its own stack, and destinations are expressed as strongly-typed enums rather than string-based routes.

```swift
// AppView.swift
struct HomeTab: View {
    var body: some View {
        ManagedNavigationStack {
            HomeView()
        }
    }
}

// Navigation link at call site
NavigationLink(to: ProfileDestination.security) {
    ProfileSettingsRow(icon: "exclamationmark.shield", title: "Security")
}
```

## Playground Apps

Xcode's SwiftUI Preview engine must compile the entire target that contains a view before it can render a preview. In a large app target this means every preview is slow to start — and a single compile error anywhere in the app can break all previews.

The Playgrounds solve this by providing small, standalone Xcode projects that import only the relevant module library:

| Playground | Imports | Covers |
|---|---|---|
| `MoviesPlayground` | `MovieApp` | All Movies feature views |
| `ProfilePlayground` | `ProfileApp` | All Profile feature views |

Because each playground depends on a focused subset of the package graph, previews rebuild in seconds rather than minutes. The `#if DEBUG` mock infrastructure (`Movie.mock`, `User.mock`, `Container.setupMovieMocks()`, etc.) is available in both playgrounds without any extra setup.

## Getting Started

1. Clone the repository.
2. Open `MovieDemo.xcodeproj`.
3. Add your TMDB API key in `AppDependencies.swift`.
4. Build and run on a simulator or device running iOS 17+.

To work on previews, open the relevant playground project from the `Playgrounds/` folder instead of the main app.

## Dependencies

| Package | Purpose |
|---|---|
| [Factory](https://github.com/hmlongco/Factory) | Dependency injection |
| [Navigator](https://github.com/hmlongco/Navigator) | Type-safe navigation |
| [Runes](https://github.com/hmlongco/Runes) | Functional operators |

## Credits

MovieDemo is designed, implemented, and maintained by [Michael Long](https://www.linkedin.com/in/hmlong/), a Lead iOS Software Engineer and a Top 1,000 Technology Writer on Medium.

* LinkedIn: [@hmlong](https://www.linkedin.com/in/hmlong/)
* Medium: [@michaellong](https://medium.com/@michaellong)
* BlueSky: [@hmlongco](https://bsky.app/profile/hmlongco.bsky.social)

That said, MovieDemo is a SwiftUI reimplementation of a demo project Bayu Kurniawan created for [Construkt](https://github.com/MainActorDev/Construkt), a SwiftUI-like declarative development library that generates UIKit code.

Construkt, in turn, is an updated version of [Builder](https://github.com/hmlongco/Builder), an open-source library I created back in the day when I wanted to use SwiftUI's' declarative syntax to build applications, but due to versioning constraints I couldn't use SwiftUI itself.

I deprecated Builder awhile back, but Bayu forked the project and is its current maintainer.

The world turns.

## License

Factory is available under the MIT license. See the LICENSE file for more info.

## Sponsors!

If you want to support my work on Factory and Navigator, consider a [GitHub Sponsorship](https://github.com/sponsors/hmlongco)! Many levels exist for increased support and even for mentorship and company training. 

Or you can just buy me a cup of coffee!

## Additional Resources

* [Medium Articles](https://medium.com/@michaellong)
* [LinkedIn](https://www.linkedin.com/in/hmlong/)
* [Factory](https://github.com/hmlongco/Factory)
* [Navigator](https://github.com/hmlongco/Navigator)
* [Runes](https://github.com/hmlongco/Runes)
