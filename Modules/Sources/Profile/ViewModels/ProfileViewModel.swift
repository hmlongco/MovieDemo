import FactoryKit
import Observation
import Shared

@Observable
@MainActor
final class ProfileViewModel {
    var authenticatedUser: User?

    @ObservationIgnored
    @Injected(\.authenticationService) private var service

    init() {
        authenticatedUser = service.authenticatedUser
    }

    func logout() {
        Task {
            await service.logout()
            authenticatedUser = service.authenticatedUser
        }
    }
}
