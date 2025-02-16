import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else {
            fatalError("could not create UIWindowScene from \(scene)")
        }
        self.window = UIWindow(windowScene: windowScene)
        self.window?.rootViewController = HomeViewController()
        self.window?.makeKeyAndVisible()
    }
}
