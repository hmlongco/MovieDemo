import UIKit

public class AppDelegate: UIResponder, UIApplicationDelegate {
    public func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        URLCache.shared = URLCache(
            memoryCapacity: 50 * 1024 * 1024,   // 50 MB memory
            diskCapacity:   300 * 1024 * 1024,  // 300 MB disk
            diskPath:       "image_cache"
        )
        
        return true
    }
}
