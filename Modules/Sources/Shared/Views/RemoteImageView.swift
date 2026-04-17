import SwiftUI

public struct RemoteImageView: View {
    private let url: URL?
    private var contentMode: ContentMode

    public  init(url: URL?, contentMode: ContentMode  = .fill) {
        self.url = url
        self.contentMode = contentMode
    }

    public var body: some View {
        if let url {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    Rectangle()
                        .fill(Color(.secondarySystemFill))
                        .shimmer()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: contentMode)
                case .failure:
                    Rectangle()
                        .fill(Color(.secondarySystemFill))
                        .overlay {
                            Image(systemName: "photo")
                                .foregroundStyle(.gray)
                        }
                @unknown default:
                    EmptyView()
                }
            }
        } else {
            Rectangle()
                .fill(Color(.secondarySystemFill))
        }
    }
}
