import Foundation

public enum LoadableState<T: Equatable>: Equatable {
    case initial
    case loading
    case loaded(T)
    case empty(String)
    case error(String)

    public var isLoading: Bool {
        switch self {
        case .loading, .initial: return true
        default: return false
        }
    }

    public var value: T? {
        if case .loaded(let value) = self { return value }
        return nil
    }
}
