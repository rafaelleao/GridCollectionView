import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var coordinator: MainCoordinator?
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = scene as? UIWindowScene else {
            return
        }

        let navController = UINavigationController()
        coordinator = MainCoordinator(navigationController: navController)
        coordinator?.start()

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navController
        window.makeKeyAndVisible()
        self.window = window
    }
}
