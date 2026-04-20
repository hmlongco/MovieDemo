import Foundation

public protocol RequestBuilding{
    func build(from endpoint: Endpoint) throws -> URLRequest
}

public final class RequestBuilder: RequestBuilding {
    private let configuration: NetworkConfiguration
    
    public init(configuration: NetworkConfiguration) {
        self.configuration = configuration
    }
    
    public func build(from endpoint: Endpoint) throws -> URLRequest {
        // 1. Construct URL
        guard var components = URLComponents(url: configuration.baseURL, resolvingAgainstBaseURL: true) else {
            throw NetworkError.invalidURL
        }
        
        // Append path (handling potential slashes)
        let basePath = components.path.trimmingCharacters(in: .init(charactersIn: "/"))
        let endpointPath = endpoint.path.trimmingCharacters(in: .init(charactersIn: "/"))
        let fullPath = basePath.isEmpty ? "/\(endpointPath)" : "/\(basePath)/\(endpointPath)"
        components.path = fullPath
        
        // Add Query Items
        if let queryItems = endpoint.queryItems {
            components.queryItems = queryItems.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
        // 2. Create Request
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        // 3. Add Default headers
        configuration.defaultHeaders.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        // 4. Add Endpoint specific headers
        endpoint.headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // 5. Add Body
        if let body = endpoint.body {
            do {
                request.httpBody = body
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                throw NetworkError.serializationError(error)
            }
        }
        
        return request
    }
}
