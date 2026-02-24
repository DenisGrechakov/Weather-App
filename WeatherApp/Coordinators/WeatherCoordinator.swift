//
//  WeatherCoordinator.swift
//  WeatherApp
//
//  Created by Гречаков Денис on 20.02.2026.
//

import UIKit

@MainActor
final class WeatherCoordinator: Coordinator {
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let weatherVC = WeatherViewController()
        navigationController.setViewControllers([weatherVC], animated: true)
    }
}
