//
//  OnboardingViewModel.swift
//  WeatherApp
//
//  Created by Гречаков Денис on 20.02.2026.
//

import Foundation
import Combine

enum OnboardingSideEffect: SideEffect {
    case finishOnboarding
    case permissionLocationDenied
}

@MainActor
final class OnboardingViewModelImpl: OnboardingViewModel {
    
    var effects: AnyPublisher<SideEffect, Never> { effectsSubject.eraseToAnyPublisher() }
    private let effectsSubject = PassthroughSubject<SideEffect, Never>()
    
    private let locationService: LocationService
    
    init(locationService: LocationService = LocationServiceImpl.shared) {
        self.locationService = locationService
    }
    
    func onClickNext() {
        if locationService.authorizationStatus == .notDetermined {
            effectsSubject.send(OnboardingSideEffect.permissionLocationDenied)
        }else {
            effectsSubject.send(OnboardingSideEffect.finishOnboarding)
        }
    }
}
