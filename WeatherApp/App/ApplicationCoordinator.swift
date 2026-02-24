//
//  ApplicationCoordinator.swift
//  WeatherApp
//
//  Created by Гречаков Денис on 20.02.2026.
//

import UIKit

@MainActor
final class ApplicationCoordinator: Coordinator {
    private let window: UIWindow
    let navigationController: UINavigationController
    private var childCoordinators: [Coordinator] = []
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }

    func start() {
        showOnboardingFlow()
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    private func showOnboardingFlow() {
        let onboardingCoordinator = OnboardingCoordinator(navigationController: navigationController)
        
        onboardingCoordinator.onFinish = { [weak self] in
            self?.childCoordinators.removeAll { $0 === onboardingCoordinator }
            self?.showWeatherFlow()
        }
        
        childCoordinators.append(onboardingCoordinator)
        onboardingCoordinator.start()
    }
    
    private func showWeatherFlow() {
        let weatherCoordinator = WeatherCoordinator(navigationController: navigationController)
        
        childCoordinators.append(weatherCoordinator)
        weatherCoordinator.start()
    }
}
