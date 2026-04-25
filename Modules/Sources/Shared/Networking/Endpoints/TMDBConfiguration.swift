import Foundation

public struct TMDBConfiguration {
    public static let baseURL = URL(string: "https://api.themoviedb.org/3")!
    
    public static var defaultHeaders: [String: String] {
        return [
            "Content-Type": "application/json",
            "Accept": "application/json",
        ]
    }
}
