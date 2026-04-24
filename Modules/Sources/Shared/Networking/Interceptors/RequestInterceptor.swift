import Foundation

public protocol RequestInterceptor: Sendable {
    func adapt(_ request: URLRequest) async throws -> URLRequest

}

// Default implementation
public extension RequestInterceptor {
    func adapt(_ request: URLRequest) async throws -> URLRequest {
        return request
    }
}
