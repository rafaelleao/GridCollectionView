import UIKit

class MainCoordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewController = SettingsViewController.instantiate()
        viewController.delegate = self
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension MainCoordinator: SettingsViewControllerDelegate {
    func showGrid(settings: GridSettings) {
        let viewModel = GridViewModel(settings: settings)
        let viewController = GridViewController.instantiate(with: viewModel)
        viewController.title = "\(settings.columns)X\(settings.rows) grid"
        navigationController.pushViewController(viewController, animated: true)
    }
}
