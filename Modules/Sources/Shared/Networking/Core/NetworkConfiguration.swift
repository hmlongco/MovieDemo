import Foundation

public struct NetworkConfiguration {
    public let baseURL: URL
    public let defaultHeaders: [String: String]
    public let verbosity: NetworkClientVerbosity

    public init(baseURL: URL, defaultHeaders: [String: String] = [:], verbosity: NetworkClientVerbosity = .debug) {
        self.baseURL = baseURL
        self.defaultHeaders = defaultHeaders
        self.verbosity = verbosity
    }
    
    // Default configuration for the Demo
    public static var `default`: NetworkConfiguration {
        return NetworkConfiguration(baseURL: URL(string: "https://api.themoviedb.org/3")!)
    }
}

public enum NetworkClientVerbosity: Int {
    case none
    case error
    case debug
    case verbose
}
