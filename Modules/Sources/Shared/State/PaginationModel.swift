import Foundation

public struct PaginationModel: Equatable {
    public let currentPage: Int
    public let isPaginating: Bool
    public let isLastPage: Bool

    public init(
        currentPage: Int = 1,
        isPaginating: Bool = false,
        isLastPage: Bool = false
    ) {
        self.currentPage = currentPage
        self.isPaginating = isPaginating
        self.isLastPage = isLastPage
    }

    public var nextPage: Int { currentPage + 1 }
}
