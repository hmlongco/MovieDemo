import SwiftUI

public struct SectionHeader: View {
    private let title: String
    
    public init(title: String) {
        self.title = title
    }

    public var body: some View {
        Text(title)
            .foregroundStyle(.white)
            .font(.system(size: 20, weight: .bold))
    }
}
