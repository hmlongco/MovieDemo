import FactoryKit
import SwiftUI
import Runes
import Shared

struct HomeGenresSection: View {
    let refreshID: Int
    let onGenreTap: (Genre) -> Void
    let onGenresLoaded: ([Genre]) -> Void

    @State private var viewModel = HomeGenresViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Genres")

            switch viewModel.state {
            case .loaded(let genres) where !genres.isEmpty:
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(genres) { genre in
                            GenreChipButton(genre: genre) { onGenreTap(genre) }
                        }
                    }
                    .padding(.horizontal, 16)
                }
            default:
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(0..<6, id: \.self) { _ in
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(.secondarySystemFill))
                                .frame(width: 80, height: 34)
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .shimmer()
            }
        }
        .padding(.top, 24)
        .task(id: refreshID) { viewModel.load() }
        .onChange(of: viewModel.currentGenres) { _, genres in
            onGenresLoaded(genres)
        }
    }
}

// MARK: - Genre Chip Button

private struct GenreChipButton: View {
    let genre: Genre
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(genre.name)
                .foregroundStyle(.white)
                .font(.system(size: 13, weight: .medium))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(Color.white.opacity(0.1))
                .cornerRadius(20)
        }
    }
}

#if DEBUG
#Preview {
    Container.shared.setupMovieMocks()
    HomeGenresSection(refreshID: 1, onGenreTap: { _ in }, onGenresLoaded: { _ in })
        .preferredColorScheme(.dark)
}
#endif
