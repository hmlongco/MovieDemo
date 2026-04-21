import Foundation

@MainActor
public class AuthenticationService: AuthenticationServices {
    public private(set) var authenticatedUser: User?

    public init() {
        #if DEBUG
        authenticatedUser = .mock
        #endif
    }

    public func login() async {
        #if DEBUG
        authenticatedUser = .mock
        #endif
    }

    public func logout() async {
        authenticatedUser = nil
    }
}
