//
//  LocationPermissionViewModel.swift
//  WeatherApp
//
//  Created by Гречаков Денис on 21.02.2026.
//

import Foundation
import Combine

enum LocationPermissionSideEffect: SideEffect {
    case finish
}

@MainActor
final class LocationPermissionViewModelImpl: LocationPermissionViewModel {
    
    var effects: AnyPublisher<SideEffect, Never> { effectsSubject.eraseToAnyPublisher() }
    private let effectsSubject = PassthroughSubject<SideEffect, Never>()
    
    private let locationService: LocationService
    
    init(locationService: LocationService = LocationServiceImpl.shared) {
        self.locationService = locationService
    }
    
    func onClickLater() {
        effectsSubject.send(LocationPermissionSideEffect.finish)
    }
    
    func onClickAllow() {
        Task {
            do {
                try await locationService.requestLocationPermission()
                await MainActor.run { [weak self] in
                    self?.effectsSubject.send(LocationPermissionSideEffect.finish)
                }
            }catch {
                print("Error: \(error)")
                await MainActor.run { [weak self] in
                    self?.effectsSubject.send(LocationPermissionSideEffect.finish)
                }
            }
        }
    }
}
