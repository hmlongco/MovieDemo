import FactoryKit
import Movies
import NavigatorUI
import Profile
import Runes
import Shared
import SwiftData
import SwiftUI

public struct AppView: View {

    @State private var appNav = AppNavigator()

    public init() {}

    public var body: some View {
        TabView(selection: $appNav.selectedTab) {
            Tab("Home", systemImage: "house", value: AppTab.home) {
                HomeTab()
            }

            Tab("Explore", systemImage: "magnifyingglass", value: AppTab.explore) {
                ExploreTab()
            }

            Tab("Profile", systemImage: "person.crop.circle", value: AppTab.profile) {
                ProfileTab()
            }
        }
//        .unsafeConditionalModifier {
//            if #available(iOS 26, *) {
//                $0.tabBarMinimizeBehavior(.onScrollDown)
//            }
//        }
        .tint(.white)
        .preferredColorScheme(.dark)
        .environment(appNav)
        .environment(\.modelContext, dependency(\.modelContext))
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
