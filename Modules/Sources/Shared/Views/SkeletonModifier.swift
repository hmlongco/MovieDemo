import SwiftUI

struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = -1

    let active: Bool

    func body(content: Content) -> some View {
        content
            .redacted(reason: active ? .placeholder : [])
            .overlay {
                if active {
                    GeometryReader { geo in
                        LinearGradient(
                            stops: [
                                .init(color: .clear,                       location: 0),
                                .init(color: .white.opacity(0.25),         location: 0.4),
                                .init(color: .white.opacity(0.5),          location: 0.5),
                                .init(color: .white.opacity(0.25),         location: 0.6),
                                .init(color: .clear,                       location: 1),
                            ],
                            startPoint: .init(x: phase, y: 0.5),
                            endPoint:   .init(x: phase + 1, y: 0.5)
                        )
                        .frame(width: geo.size.width * 3)
                        .offset(x: geo.size.width * (phase - 0.5))
                    }
                    .allowsHitTesting(false)
                }
            }
            .onAppear {
                if active {
                    withAnimation(.linear(duration: 1.4).delay(0.2).repeatForever(autoreverses: false)) {
                        phase = 1
                    }
                }
            }
    }
}

extension View {
    public func shimmer(active: Bool = true) -> some View {
        modifier(ShimmerModifier(active: active))
    }
}

#if DEBUG
#Preview {
    VStack {
        Text("Hello World")
            .padding(20)
    }
    .background(Color.secondary)
    .shimmer()
}
#endif
