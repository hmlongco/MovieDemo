import SwiftUI
import NavigatorUI
import Runes
import Shared

let posterHeight: CGFloat = 180

struct MovieListView: View {

    @State var viewModel: MovieListViewModel
    @Environment(\.navigator) private var navigator

    private let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        VStack(spacing: 0) {
            genreFilter
            movieGrid
        }
        .background(Color(hex: "0A0A0A").ignoresSafeArea())
        .navigationTitle(viewModel.title)
        .task {
            viewModel.initialLoad()
        }
    }

    // MARK: - Genre Filter

    @ViewBuilder
    private var genreFilter: some View {
        if !viewModel.filterItems.isEmpty {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(viewModel.filterItems) { item in
                        GenreChip(title: item.title, isSelected: item.isSelected) {
                            viewModel.selectGenre(item.genre)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
            }
        }
    }

    // MARK: - Movie Grid

    private var movieGrid: some View {
        ScrollView {
            if viewModel.isLoading && viewModel.movies.isEmpty {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(0..<6, id: \.self) { _ in
                        MovieGridSkeletonCell()
                    }
                }
                .padding(.horizontal, 16)
            } else {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(viewModel.movies) { movie in
                        MovieGridCell(movie: movie)
                            .onTapGesture {
                                navigator.navigate(to: MovieDestination.movieDetail(movieId: movie.id))
                            }
                            .onAppear {
                                if movie.id == viewModel.movies.last?.id {
                                    viewModel.loadMore()
                                }
                            }
                    }

                    if viewModel.paginationState.isPaginating {
                        ProgressView()
                            .tint(.white)
                            .frame(maxWidth: .infinity)
                            .gridCellColumns(2)
                            .padding(.vertical, 12)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .scrollIndicators(.hidden)
        .refreshable { await viewModel.refresh() }
    }
}

// MARK: - Movie Grid Cell

private struct MovieGridCell: View {
    let movie: Movie

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            RemoteImageView(url: movie.posterURL)
                .frame(height: posterHeight)
                .cornerRadius(8)
                .clipped()

            Text(movie.title)
                .foregroundStyle(.white)
                .font(.system(size: 13, weight: .medium))
                .lineLimit(1)

            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .foregroundStyle(.yellow)
                    .font(.system(size: 10))
                Text(String(format: "%.1f", movie.voteAverage))
                    .foregroundStyle(Color(hex: "A3A3A3"))
                    .font(.system(size: 12))
            }
        }
    }
}

private struct MovieGridSkeletonCell: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.secondarySystemFill))
                .frame(height: posterHeight)
            RoundedRectangle(cornerRadius: 4)
                .fill(Color(.secondarySystemFill))
                .frame(height: 14)
            RoundedRectangle(cornerRadius: 4)
                .fill(Color(.secondarySystemFill))
                .frame(width: 60, height: 12)
        }
        .shimmer()
    }
}

// MARK: - Genre Chip

private struct GenreChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(isSelected ? .black : .white)
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(isSelected ? Color.white : Color.white.opacity(0.1))
                .cornerRadius(20)
        }
    }
}
