import Foundation

public struct TMDBRequestInterceptor: RequestInterceptor {
    private let apiKey: String
    
    public init(apiKey: String?) {
        self.apiKey = apiKey ?? "mock-api-key"
    }
    
    public func adapt(_ request: URLRequest) async throws -> URLRequest {
        var request = request
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Authorization"] = "Bearer \(apiKey)"
        request.allHTTPHeaderFields = headers
        return request
    }
}
