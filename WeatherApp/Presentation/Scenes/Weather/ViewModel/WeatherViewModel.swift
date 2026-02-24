//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Гречаков Денис on 20.02.2026.
//

import Foundation
import CoreLocation
import Combine

@MainActor
final class WeatherViewModelImpl: WeatherViewModel {
    
    private(set) var state: AnyPublisher<WeatherState, Never>
    private let stateSubject: CurrentValueSubject<WeatherState, Never>
    
    private let networkService: NetworkService
    private let locationService: LocationService
    
    init(
        locationService: LocationService = LocationServiceImpl.shared,
        networkService: NetworkService = NetworkServiceImpl(),
    ) {
        let initialState = WeatherState()
        self.stateSubject = CurrentValueSubject(initialState)
        self.state = stateSubject.eraseToAnyPublisher()
        
        self.networkService = networkService
        self.locationService = locationService
    }
    
    func onCreate() {
        fetchWeather()
    }
    
    func onStart() {
        guard self.stateSubject.value.isLoading == false else {
            return
        }
        fetchWeather()
    }
    
    func onRetry() {
        fetchWeather()
    }
    
    private func fetchWeather() {
        var state = self.stateSubject.value
        state.isLoading = true
        state.isShowRetry = false
        self.stateSubject.send(state)
        
        Task {
            let fallbackPosition = CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6173) //Москва
            
            let position: CLLocationCoordinate2D
            do {
                position = try await locationService.requestCurrentLocation()
            } catch is LocationError {
                position = fallbackPosition
            }
            
            do {
                let resultCurrentWeather: CurrentWeatherResponse = try await networkService.request(.currentWeather(lat: position.latitude, lon: position.longitude))
            
                let resultForecastWeather: ForecastWeatherResponse = try await networkService.request(.forecast(lat: position.latitude, lon: position.longitude, days: 3))
                
                await updateWeatherState(current: resultCurrentWeather, forecast: resultForecastWeather)
            }catch {
                print("Error: \(error)")
                
                await MainActor.run {
                    var state = self.stateSubject.value
                    state.isLoading = false
                    state.isShowRetry = true
                    self.stateSubject.send(state)
                }
            }
        }
    }
    
    private func updateWeatherState(current: CurrentWeatherResponse, forecast: ForecastWeatherResponse) async {
        await MainActor.run {
            var state = self.stateSubject.value
            state.isLoading = false

            // --- Header ---
            state.headerInfo = WeatherState.HeaderInfo(
                name: current.location.name,
                region: current.location.region,
                country: current.location.country,
                temperature: String(format: "%.0f°", current.current.tempC),
                iconURL: current.current.condition.icon,
                feelsLike: String(format: "%.0f°", current.current.feelslikeC)
            )

            // --- Additional Info ---
            state.additionalInfo = WeatherState.AdditionalInfo(
                uvIndex: String(format: "%.0f", current.current.uv),
                wind: String(format: "%.0f km/h", current.current.windKph),
                humidity: "\(current.current.humidity)%"
            )

            // --- Sun Info ---
            if let today = forecast.forecast.forecastday.first {
                state.sunInfo = WeatherState.SunInfo(
                    sunrise: today.astro.sunrise,
                    sunset: today.astro.sunset
                )
            }

            // --- Hourly Forecast ---
            if let today = forecast.forecast.forecastday.first {
                let now = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm"

                state.hourlyForecast = today.hour
                    .filter { hour in
                        guard let date = formatter.date(from: hour.time) else { return false }
                        return date >= now
                    }
                    .map { hour in
                        let time = String(hour.time.suffix(5)) // HH:mm
                        let temp = String(format: "%.0f°", hour.tempC)
                        let icon = hour.condition.icon
                        return WeatherState.HourlyWeather(time: time, temperature: temp, iconName: icon)
                    }
                
                //add weather now
                state.hourlyForecast.insert(WeatherState.HourlyWeather(
                    time: NSLocalizedString("hourly_now", comment: ""),
                    temperature: state.headerInfo.temperature,
                    iconName: state.headerInfo.iconURL), at: 0)
            }

            // --- Daily Forecast ---
            state.dailyForecast = forecast.forecast.forecastday.prefix(3).map { day in
                let dayName = formatDateToDayName(day.date)
                let minTemp = String(format: "%.0f°", day.day.mintempC)
                let maxTemp = String(format: "%.0f°", day.day.maxtempC)
                let icon = day.day.condition.icon
                return WeatherState.DailyWeather(day: dayName, minTemp: minTemp, maxTemp: maxTemp, iconName: icon)
            }

            self.stateSubject.send(state)
        }
    }

    // MARK: - Helpers
    private func formatDateToDayName(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: dateString) else { return dateString }

        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EEE"
        return dayFormatter.string(from: date)
    }
}
