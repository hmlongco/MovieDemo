import Foundation

public typealias NetworkResult = Decodable & Sendable

public protocol NetworkClient: Sendable {
    func request(_ endpoint: Endpoint) async throws -> (Data?, HTTPURLResponse?)
    func request<T: NetworkResult>(_ endpoint: Endpoint) async throws -> T

    func mock(_ endpoint: any Endpoint, data: Data)
    func mock<T: NetworkResult>(_ endpoint: any Endpoint, value: T)
    func mock<E: Error>(_ endpoint: any Endpoint, error: E)

    func reset(_ endpoint: any Endpoint)
    func resetAll() async
}

extension NetworkClient {
    func request(_ endpoint: Endpoint) async throws -> Data {
        guard let data = try await request(endpoint).0 else {
            throw NetworkError.invalidResponse
        }
        return data
    }
}
