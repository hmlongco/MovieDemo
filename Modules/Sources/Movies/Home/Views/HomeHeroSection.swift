import FactoryKit
import SwiftUI
import NavigatorUI
import Runes
import Shared

struct HomeHeroSection: View {
    let refreshID: Int
    let onMovieTap: (Movie) -> Void

    @Environment(\.sceneGeometry) var geo
    @State private var viewModel = HomeHeroViewModel()

    var body: some View {
        Group {
            switch viewModel.state {
            case .loaded(let movies) where !movies.isEmpty:
                TabView {
                    ForEach(movies.prefix(5)) { movie in
                        HeroCard(movie: movie, width: geo.size.width, height: 520)
                            .onTapGesture { onMovieTap(movie) }
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .ignoresSafeArea(edges: .horizontal)
                .frame(height: 520)

            default:
                ZStack(alignment: .bottomLeading) {
                    Rectangle()
                        .fill(Color(.secondarySystemFill))
                        .frame(maxWidth: .infinity)
                        .frame(height: 520)
                    VStack(alignment: .leading, spacing: 8) {
                        RoundedRectangle(cornerRadius: 4).fill(Color(hex: "2C2C2E")).frame(width: 200, height: 28)
                        RoundedRectangle(cornerRadius: 4).fill(Color(hex: "2C2C2E")).frame(width: 140, height: 16)
                    }
                    .padding(24)
                }
                .shimmer()
            }
        }
        .task(id: refreshID) { await viewModel.load() }
    }
}

#if DEBUG
#Preview {
    Container.shared.setupMovieMocks()
    VStack {
        HomeHeroSection(refreshID: 1, onMovieTap: { _ in })
            .preferredColorScheme(.dark)
        Spacer()
    }
    .ignoresSafeArea(.all)
}
#endif
