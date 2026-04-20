import Movies
import NavigatorUI
import Profile
import Runes
import Shared
import SwiftUI

public struct AppView: View {

    @Environment(\.appDependencies) private var appDependencies
    @Environment(\.appNav) private var appNav

    public init() {}

    public var body: some View {
        TabView(selection: Bindable(appNav).selectedTab) {
            HomeTab()
                .tabItem { Label("Home",    systemImage: "house") }
                .tag(AppTab.home)

            ExploreTab()
                .tabItem { Label("Explore", systemImage: "magnifyingglass") }
                .tag(AppTab.explore)

            ProfileTab()
                .tabItem { Label("Profile", systemImage: "person.crop.circle") }
                .tag(AppTab.profile)
        }
        .tint(.white)
        .preferredColorScheme(.dark)
        .environment(\.movieDependencies, appDependencies)
        .environment(\.profileDependencies, appDependencies)
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

struct ProfileTab: View {
    var body: some View {
        ManagedNavigationStack {
            ProfileView()
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}
