//
//  StandardNetworkClient.swift
//  Modules
//
//  Created by Michael Long on 4/23/26.
//

import Foundation

public final class StandardNetworkClient: NetworkClient, @unchecked Sendable {
    private let session: URLSession
    private let requestBuilder: RequestBuilder
    private let interceptors: [RequestInterceptor]
    private let verbosity: NetworkClientVerbosity
    private var registry: [String: Any] = [:]

    public init(
        configuration: NetworkConfiguration = .default,
        session: URLSession = .shared,
        interceptors: [RequestInterceptor] = []
    ) {
        self.session = session
        self.requestBuilder = RequestBuilder(configuration: configuration)
        self.interceptors = interceptors
        self.verbosity = configuration.verbosity
    }

    // MARK: - Request

    public func request(_ endpoint: Endpoint) async throws -> (Data?, HTTPURLResponse?) {
        if let data: Data = try mock(for: endpoint) {
            return (data, nil)
        }

        var request = try requestBuilder.build(from: endpoint)

        for interceptor in interceptors {
            request = try await interceptor.adapt(request)
        }

        let path = request.url?.absoluteString ?? "unknown"
        print("REQ: \(path)")

        do {
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }

            let status = httpResponse.statusCode ?? 999
            print("\(status): \(path)")

            return (data, httpResponse)
        } catch {
            print("ERR: \(path) - \(error.localizedDescription)")
            throw error
        }
    }

    public func request<T: NetworkResult>(_ endpoint: Endpoint) async throws -> T {
        if let mock: T = try mock(for: endpoint) {
            return mock
        }

        let (data, _) = try await request(endpoint)

        guard let data else {
            throw NetworkError.invalidResponse
        }

        do {
            let decodedResponse = try endpoint.decoder.decode(T.self, from: data)
            if verbosity == .verbose, let text = String(data: data, encoding: .utf8) {
                print("DAT: \(text)")
            }
            return decodedResponse
        } catch {
            print("ERR: \(error)")
            throw NetworkError.decodingError(error)
        }
    }

    private func mock<T>(for endpoint: any Endpoint) throws -> T? {
        guard let found = registry[endpoint.id] else {
            return nil
        }
        if let typed = found as? T {
            return typed
        }
        if let error = found as? Error {
            throw error
        }
        return nil
    }

    // MARK: - Mock/Error/Test Registration

    public func mock(_ endpoint: any Endpoint, data: Data) {
        registry[endpoint.id] = data
    }

    public func mock(_ endpoint: any Endpoint, json: String) {
        registry[endpoint.id] = json.data(using: .utf8)
    }

    public func mock<T: NetworkResult>(_ endpoint: any Endpoint, value: T) {
        registry[endpoint.id] = value
    }

    public func mock<E: Error>(_ endpoint: any Endpoint, error: E) {
        registry[endpoint.id] = error
    }

    public func reset(_ endpoint: any Endpoint) {
        registry.removeValue(forKey: endpoint.id)
    }

    public func resetAll() {
        registry.removeAll()
    }

}
