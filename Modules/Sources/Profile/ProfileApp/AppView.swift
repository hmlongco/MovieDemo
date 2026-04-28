import NavigatorUI
import Profile
import Runes
import Shared
import SwiftUI

public struct AppView: View {

    public init() {}

    public var body: some View {
        ManagedNavigationStack {
            ProfileView()
        }
        .tint(.white)
        .preferredColorScheme(.dark)
    }
    
}
