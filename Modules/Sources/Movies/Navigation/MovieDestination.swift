import Shared
import SwiftUI
import NavigatorUI

public enum MovieDestination: NavigationDestination {

    case movieDetail(movieId: String)
    case movieList(title: String, sectionTypeRaw: String, genreId: Int?, genreName: String?, allGenres: [Genre]?)
    case search

    public var body: some View {
        MovieDestinationView(destination: self)
    }

}

struct MovieDestinationView: View {

    @Environment(\.movieDependencies) var movieDependencies

    let destination: MovieDestination

    var body: some View {
        switch destination {
        case .movieDetail(let movieId):
            MovieDetailView(movieId: movieId)

        case .movieList(let title, let sectionTypeRaw, let genreId, let genreName, let allGenres):
            let sectionType = HomeSection(rawValue: sectionTypeRaw) ?? .categories
            let selectedGenre: Genre? = if let id = genreId, let name = genreName {
                Genre(id: id, name: name)
            } else {
                nil
            }
            MovieListView(
                viewModel: MovieListViewModel(
                    title: title,
                    sectionType: sectionType,
                    genres: allGenres ?? (selectedGenre.map { [$0] } ?? []),
                    selectedGenre: selectedGenre
                )
            )

        case .search:
            SearchView()
        }
    }
}
