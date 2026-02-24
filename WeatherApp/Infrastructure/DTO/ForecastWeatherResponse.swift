//
//  ForecastWeatherResponse.swift
//  WeatherApp
//
//  Created by Гречаков Денис on 21.02.2026.
//

import Foundation

// MARK: - Root
struct ForecastWeatherResponse: Codable {
    let location: LocationDTO
    let current: CurrentDTO
    let forecast: ForecastDTO
}

// MARK: - Forecast
struct ForecastDTO: Codable {
    let forecastday: [ForecastDayDTO]
}

// MARK: - Forecast Day
struct ForecastDayDTO: Codable {
    let date: String
    let dateEpoch: Int
    let day: DayDTO
    let astro: AstroDTO
    let hour: [HourDTO]
    
    enum CodingKeys: String, CodingKey {
        case date
        case dateEpoch = "date_epoch"
        case day
        case astro
        case hour
    }
}

// MARK: - Day
struct DayDTO: Codable {
    let maxtempC: Double
    let mintempC: Double
    let avgtempC: Double
    let maxwindKph: Double
    let totalprecipMm: Double
    let avghumidity: Double
    let dailyChanceOfRain: Int
    let condition: ConditionDTO
    
    enum CodingKeys: String, CodingKey {
        case maxtempC = "maxtemp_c"
        case mintempC = "mintemp_c"
        case avgtempC = "avgtemp_c"
        case maxwindKph = "maxwind_kph"
        case totalprecipMm = "totalprecip_mm"
        case avghumidity
        case dailyChanceOfRain = "daily_chance_of_rain"
        case condition
    }
}

// MARK: - Hour
struct HourDTO: Codable {
    let time: String
    let tempC: Double
    let isDay: Int
    let condition: ConditionDTO
    let windKph: Double
    let humidity: Int
    let chanceOfRain: Int
    
    enum CodingKeys: String, CodingKey {
        case time
        case tempC = "temp_c"
        case isDay = "is_day"
        case condition
        case windKph = "wind_kph"
        case humidity
        case chanceOfRain = "chance_of_rain"
    }
}

// MARK: - Astro
struct AstroDTO: Codable {
    let sunrise: String
    let sunset: String
    let moonrise: String
    let moonset: String
}

// MARK: - Shared DTOs

struct ConditionDTO: Codable {
    let text: String
    let icon: String
    let code: Int
}

struct LocationDTO: Codable {
    let name: String
    let region: String
    let country: String
    let lat: Double
    let lon: Double
    let localtime: String
}

struct CurrentDTO: Codable {
    let tempC: Double
    let isDay: Int
    let condition: ConditionDTO
    let windKph: Double
    let humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case tempC = "temp_c"
        case isDay = "is_day"
        case condition
        case windKph = "wind_kph"
        case humidity
    }
}
