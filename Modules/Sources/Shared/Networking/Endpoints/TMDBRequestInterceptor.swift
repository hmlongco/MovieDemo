import Foundation

public struct TMDBRequestInterceptor: RequestInterceptor {
    private let apiKey: String
    
    public init(apiKey: String?) {
        self.apiKey = apiKey ?? "mock-api-key"
    }
    
    public func adapt(_ request: URLRequest) async throws -> URLRequest {
        var request = request
        guard let url = request.url else { return request }
        
        // Append api_key query parameter
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        var queryItems = components?.queryItems ?? []
        queryItems.append(URLQueryItem(name: "api_key", value: apiKey))
        components?.queryItems = queryItems
        
        if let newURL = components?.url {
            request.url = newURL
        }
        
        return request
    }
}
