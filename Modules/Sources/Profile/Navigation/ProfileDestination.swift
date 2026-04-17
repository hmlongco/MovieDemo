import SwiftUI
import NavigatorUI
import Shared

public enum ProfileDestination: NavigationDestination {
    case downloads
    case notifications
    case darkMode
    case paymentMethods
    case security
    case logOut

    public var body: some View {
        switch self {
        case .downloads:      ProfileDownloadsView()
        case .notifications:  ProfileNotificationsView()
        case .darkMode:       ProfileDarkModeView()
        case .paymentMethods: ProfilePaymentMethodsView()
        case .security:       ProfileSecurityView()
        case .logOut:         ProfileLogOutView()
        }
    }
}
