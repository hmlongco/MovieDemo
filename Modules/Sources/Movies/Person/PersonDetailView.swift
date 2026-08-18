import FactoryKit
import Runes
import Shared
import SwiftUI

struct PersonDetailView: View {

    let personId: Int
    @State private var viewModel = PersonDetailViewModel()

    var body: some View {
        ScrollView {
            switch viewModel.detailState {
            case .initial, .loading:
                PersonDetailContent(detail: .mock1, filmography: [.mock1, .mock2, .mock3])
                    .redacted(reason: .placeholder)
                    .shimmer()
                    .task {
                         await viewModel.load(personId: personId)
                    }

            case .loaded(let detail):
                PersonDetailContent(detail: detail, filmography: viewModel.filmography)

            case .error(let message):
                Text(message)
                    .foregroundStyle(.red.opacity(0.8))
                    .padding(24)

            case .empty:
                EmptyView()
            }
        }
        .background(Color(hex: "0A0A0A").ignoresSafeArea())
        .scrollIndicators(.hidden)
        .navigationTitle("Cast/Credits")
    }
}

#if DEBUG
#Preview {
    Container.shared.setupMovieMocks()
    PersonDetailView(personId: 1)
}
#endif
