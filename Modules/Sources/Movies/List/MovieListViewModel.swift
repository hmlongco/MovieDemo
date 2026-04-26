import Foundation
import FactoryKit
import Runes
import Shared

@Observable
@MainActor
final class MovieListViewModel {

    // MARK: - State
    private(set) var movies:          [Movie]              = []
    var             selectedGenre:    Genre?               = nil
    private(set) var isLoading:       Bool                 = false
    private(set) var error:           String?              = nil
    private(set) var paginationState: PaginationModel  = PaginationModel()

    struct FilterItem: Identifiable, Equatable, Hashable {
        let id: Int
        let title: String
        let isSelected: Bool
        let genre: Genre?
    }

    var filterItems: [FilterItem] {
        let allItem = FilterItem(id: -1, title: "All", isSelected: selectedGenre == nil, genre: nil)
        let items = genres.map { genre in
            FilterItem(
                id: genre.id,
                title: genre.name,
                isSelected: selectedGenre?.id == genre.id,
                genre: genre
            )
        }
        return [allItem] + items
    }

    // MARK: - Properties
    let title:    String
    let genres:   [Genre]
    private let sectionType: HomeSection

    // MARK: - Dependencies
    @ObservationIgnored
    @Injected(\.movieRepository) private var service

    // MARK: - Init
    init(
        title: String,
        sectionType: HomeSection,
        genres: [Genre],
        selectedGenre: Genre?,
        service: MovieServices? = nil
    ) {
        self.title        = title
        self.sectionType  = sectionType
        self.genres       = genres
        self.selectedGenre = selectedGenre
    }

    func initialLoad() async {
        await fetchMovies(reset: true)
    }

    // MARK: - Actions
    func selectGenre(_ genre: Genre?) {
        guard selectedGenre != genre else { return }
        selectedGenre = genre
        Task { await fetchMovies(reset: true) }
    }

    func loadMore() {
        guard !paginationState.isPaginating, !paginationState.isLastPage else { return }
        Task { await fetchMovies(reset: false) }
    }

    func refresh() async {
        await fetchMovies(reset: true)
    }

    // MARK: - Private
    private func fetchMovies(reset: Bool) async {
        if reset {
            movies    = []
            isLoading = true
            paginationState = PaginationModel(currentPage: 1, isPaginating: false, isLastPage: false)
        } else {
            paginationState = PaginationModel(
                currentPage:  paginationState.currentPage,
                isPaginating: true,
                isLastPage:   paginationState.isLastPage
            )
        }

        do {
            let currentPage = paginationState.currentPage
            let response: MovieResponse

            if let genre = selectedGenre {
                response = try await service.discoverMovies(page: currentPage, genreId: genre.id)
            } else {
                switch sectionType {
                case .popular:
                    response = try await service.getPopularMovies(page: currentPage)
                case .upcoming:
                    response = try await service.getNowPlayingMovies(page: currentPage)
                case .topRated:
                    response = try await service.getTopRatedMovies(page: currentPage)
                case .hero, .categories:
                    response = try await service.getNowPlayingMovies(page: currentPage)
                }
            }

            if reset {
                movies = response.results
            } else {
                movies.append(contentsOf: response.results)
            }

            let nextPage   = currentPage + 1
            let isLastPage = nextPage > response.totalPages
            paginationState = PaginationModel(
                currentPage:  nextPage,
                isPaginating: false,
                isLastPage:   isLastPage
            )
            isLoading = false

        } catch {
            self.error = error.localizedDescription
            paginationState = PaginationModel(
                currentPage:  paginationState.currentPage,
                isPaginating: false,
                isLastPage:   paginationState.isLastPage
            )
            isLoading = false
        }
    }
}
