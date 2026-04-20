//
//  ProfileDependencies.swift
//  Modules
//
//  Created by Michael Long on 4/19/26.
//

import Foundation
import Shared
import SwiftUI

public protocol ProfileDependencies: DependencyContainer
    & SharedDependencies
{}

public final class MockProfileContainer: ProfileDependencies {
    public var cache: Shared.DependencyCache = .init()
    // Missing conformances
    public var apiKey: String = "mock-api-key"
}

extension EnvironmentValues {
    @Entry public var profileDependencies: ProfileDependencies = MockProfileContainer()
}
