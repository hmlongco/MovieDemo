import Foundation

public protocol Endpoint: Identifiable, Sendable {
    /// The path to be appended to the base URL (e.g., "/users")
    var path: String { get }
    
    /// The HTTP method to use (e.g., .get, .post)
    var method: HTTPMethod { get }
    
    /// Optional headers specific to this endpoint
    var headers: [String: String]? { get }
    
    /// Optional body data to be encoded as JSON
    var body: Data? { get }

    /// Optional query parameters
    var queryItems: [String: String]? { get }
}

// Default implementation for convenience
public extension Endpoint {
    var id: String {
        method.rawValue + path
    }
    var headers: [String: String]? {
        return nil
    }
    var body: Data? {
        return nil
    }
    var queryItems: [String: String]? {
        return nil
    }
}
