//
//  WeatherViewModelProtocol.swift
//  WeatherApp
//
//  Created by Гречаков Денис on 20.02.2026.
//

@MainActor
protocol WeatherViewModel {
    func onCreate()
    func onStart()
    func onRetry()
}
