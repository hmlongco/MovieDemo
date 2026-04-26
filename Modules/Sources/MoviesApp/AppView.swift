import Movies
import NavigatorUI
import Runes
import Shared
import SwiftUI

public struct AppView: View {

    @State private var appNav = AppNavigator()

    public init() {}

    public var body: some View {
        TabView(selection: $appNav.selectedTab) {
            HomeTab()
                .tabItem { Label("Home",    systemImage: "house") }
                .tag(AppTab.home)

            ExploreTab()
                .tabItem { Label("Explore", systemImage: "magnifyingglass") }
                .tag(AppTab.explore)
        }
        .tint(.white)
        .preferredColorScheme(.dark)
        .environment(appNav)
    }
}

// MARK: - Tabs

struct HomeTab: View {
    var body: some View {
        ManagedNavigationStack {
            HomeView()
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

struct ExploreTab: View {
    var body: some View {
        ManagedNavigationStack {
            ExploreView()
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}
