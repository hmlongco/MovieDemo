import FactoryMacros
import Shared

@Dependency(\.authenticationService)
@MainActor @Observable final class ProfileViewModel {
    var authenticatedUser: User?

    init() {
        authenticatedUser = authenticationService.authenticatedUser
    }

    func logout() {
        Task {
            await authenticationService.logout()
            authenticatedUser = authenticationService.authenticatedUser
        }
    }
}
