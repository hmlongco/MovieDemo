//
//  AppContainer.swift
//  Modules
//
//  Created by Michael Long on 4/19/26.
//

import Movies
import Profile
import Shared
import SwiftUI

public protocol AppDependencies: DependencyContainer
    & MovieDependencies
    & ProfileDependencies
    & SharedDependencies
{}

public class AppContainer: AppDependencies {
    // DependencyContainer conformance
    public var cache: Shared.DependencyCache  = .init()

    // Missing MovieDependencies conformances
    public var apiKey = "8df8d91448f1224d5a8ad39cffdcbc41"
}

extension EnvironmentValues {
    @Entry var appDependencies: AppDependencies = AppContainer()
}
