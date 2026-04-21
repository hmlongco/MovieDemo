import Foundation

public struct User: Codable, Equatable, Sendable {
    public let fullName: String
    public let userName: String
    public let membershipDate: Date

    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case userName = "user_name"
        case membershipDate = "membership_date"
    }
}

#if DEBUG
public extension User {
    static var mock: User {
        User(
            fullName: "Michael Long",
            userName: "mlong",
            membershipDate: Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 2))!
        )
    }
}
#endif
