import Foundation

@MainActor
public protocol AuthenticationServices: Sendable {
    var authenticatedUser: User? { get }
    func login() async
    func logout() async
}

public extension AuthenticationServices {
    public var isAuthenticated: Bool {
        authenticatedUser != nil
    }
}
