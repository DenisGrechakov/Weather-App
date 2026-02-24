//
//  OnboardingCoordinator.swift
//  WeatherApp
//
//  Created by Гречаков Денис on 20.02.2026.
//

import UIKit

@MainActor
final class OnboardingCoordinator: Coordinator {
    let navigationController: UINavigationController
    var onFinish: (() -> Void)?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let onboardingVC = OnboardingViewController()
        
        onboardingVC.onFinihed = { [weak self] in
            self?.onFinish?()
        }
        
        onboardingVC.onPermissionGranted = { [weak self] in
            self?.showPermissionLocation()
        }
        
        navigationController.setViewControllers([onboardingVC], animated: false)
    }
    
    func showPermissionLocation() {
        let locationPermissionVC = LocationPermissionViewController()
        
        locationPermissionVC.onFinihed = { [weak self] in
            self?.onFinish?()
        }
        
        navigationController.pushViewController(locationPermissionVC, animated: true)
    }
}
