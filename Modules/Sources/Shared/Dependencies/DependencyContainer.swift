//
//  DependencyContainer.swift
//  MovieDemo
//
//  Created by Michael Long on 1/29/25.
//

import Foundation
import NavigatorUI

public protocol DependencyContainer: AnyObject {
    var cache: DependencyCache { get }
}

extension DependencyContainer {

    @inlinable public func register<T>(_ value: T) {
        cache.register(value)
    }

    @inlinable public func registering<T>(_ value: T) -> Self {
        cache.register(value)
        return self
    }

    @inlinable public func cached<T>(_ factory: @escaping () -> T) -> T {
        cache.cached(factory)
    }

    @inlinable public func shared<T: AnyObject>(_ factory: @escaping () -> T) -> T {
        cache.shared(factory)
    }

    @inlinable public func singleton<T>(_ factory: @escaping () -> T) -> T {
        cache.singleton(factory)
    }

    @inlinable public func unique<T>(_ factory: @escaping () -> T) -> T {
        cache.unique(factory)
    }

    @inlinable public func with(modifier: (Self) -> Void) -> Self {
        modifier(self)
        return self
    }

}

public class DependencyCache: @unchecked Sendable {

    public init() {
        // public
    }

    public func register<T>(_ value: T) {
        lock.withLock {
            registrations[ObjectIdentifier(T.self)] = value
        }
    }

    public func cached<T>(_ factory: @escaping () -> T) -> T {
        lock.withLock {
            // print("Resolving \(T.self)")
            let id = ObjectIdentifier(T.self)
            if let cached: T = registrations[id] as? T ?? cache[id] as? T {
                return cached
            }
            let instance: T = factory()
            cache[id] = instance
            return instance
        }
    }

    public func shared<T: AnyObject>(_ factory: @escaping () -> T) -> T {
        lock.withLock {
            // print("Resolving \(T.self)")
            let id = ObjectIdentifier(T.self)
            if let registered: T = registrations[id] as? T {
                return registered
            }
            if let found = cache[id] as? WeakObject<T>, let cached = found.object {
                return cached
            }
            let instance: T = factory()
            cache[id] = WeakObject(object: instance)
            return instance
        }
    }

    public func singleton<T>(_ factory: @escaping () -> T) -> T {
        lock.withLock {
            // print("Resolving \(T.self)")
            let id = ObjectIdentifier(T.self)
            if let cached: T = registrations[id] as? T ?? Self.singletons[id] as? T {
                return cached
            }
            let instance: T = factory()
            Self.singletons[id] = instance
            return instance
        }
    }

    public func unique<T>(_ factory: @escaping () -> T) -> T {
        lock.withLock {
            // print("Resolving \(T.self)")
            if let cached: T = registrations[ObjectIdentifier(T.self)] as? T {
                return cached
            }
            return factory()
        }
    }

    public func reset(includingSingletons: Bool = false) {
        lock.withLock {
            if includingSingletons {
                Self.singletons = [:]
            }
            registrations = [:]
            cache = [:]
        }
    }

    public func clear() {
        lock.withLock {
            cache = [:]
        }
    }

    private nonisolated(unsafe) static var singletons: [ObjectIdentifier: Any] = [:]

    private var lock: NSRecursiveLock = .init()
    private var cache: [ObjectIdentifier: Any] = [:]
    private var registrations: [ObjectIdentifier: Any] = [:]

    private struct WeakObject<T: AnyObject> {
        weak var object: T?
    }

}
