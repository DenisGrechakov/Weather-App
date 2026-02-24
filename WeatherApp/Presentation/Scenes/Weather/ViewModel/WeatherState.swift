//
//  WeatherState.swift
//  WeatherApp
//
//  Created by Гречаков Денис on 20.02.2026.
//

struct WeatherState {
    // --- Общий статус ---
    var isLoading: Bool = true
    var isShowRetry: Bool = false
    
    // --- HeaderSectionView ---
    struct HeaderInfo {
        var name: String
        var region: String
        var country: String
        var temperature: String
        var iconURL: String
        var feelsLike: String
    }
    var headerInfo: HeaderInfo = HeaderInfo(name: "",
                                            region: "",
                                            country: "",
                                            temperature: "",
                                            iconURL: "",
                                            feelsLike: "")
    
    // --- AdditionalInfoSectionView ---
    struct AdditionalInfo {
        var uvIndex: String
        var wind: String
        var humidity: String
    }
    var additionalInfo: AdditionalInfo = AdditionalInfo(uvIndex: "",
                                                        wind: "",
                                                        humidity: "")
    
    // --- SunSectionView ---
    struct SunInfo {
        var sunrise: String
        var sunset: String
    }
    var sunInfo: SunInfo = SunInfo(sunrise: "", sunset: "")
    
    // --- HourlySectionView ---
    struct HourlyWeather {
        var time: String
        var temperature: String
        var iconName: String
    }
    var hourlyForecast: [HourlyWeather] = []
    
    // --- DailySectionView ---
    struct DailyWeather {
        var day: String
        var minTemp: String
        var maxTemp: String
        var iconName: String
    }
    var dailyForecast: [DailyWeather] = []
}
