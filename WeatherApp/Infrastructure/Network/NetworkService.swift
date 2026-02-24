//
//  NetworkService.swift
//  WeatherApp
//
//  Created by Гречаков Денис on 20.02.2026.
//

import Foundation
import NetworkExtension

enum APIEndpoint {
    case currentWeather(lat: Double, lon: Double)
    case forecast(lat: Double, lon: Double, days: Int)
    
    private var baseURL: String {
        "https://api.weatherapi.com/v1"
    }
    
    private var apiKey: String {
        "fa8b3df74d4042b9aa7135114252304"
    }
    
    var url: URL? {
        switch self {
        case .currentWeather(let lat, let lon):
            var components = URLComponents(string: "\(baseURL)/current.json")
            components?.queryItems = [
                URLQueryItem(name: "key", value: apiKey),
                URLQueryItem(name: "q", value: "\(lat),\(lon)")
            ]
            return components?.url
            
        case .forecast(let lat, let lon, let days):
            var components = URLComponents(string: "\(baseURL)/forecast.json")
            components?.queryItems = [
                URLQueryItem(name: "key", value: apiKey),
                URLQueryItem(name: "q", value: "\(lat),\(lon)"),
                URLQueryItem(name: "days", value: "\(days)")
            ]
            return components?.url
        }
    }
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case unauthorized
    case notFound
    case serverError(code: Int)
    case decodingFailed(Error)
}

protocol NetworkService {
    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T
}

final class NetworkServiceImpl: NetworkService {
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {
        
        guard let url = endpoint.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 30
        
        let (data, response) = try await session.data(for: request)
        
        try validate(response: response)
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed(error)
        }
    }
    
    private func validate(response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            return
        case 401:
            throw NetworkError.unauthorized
        case 404:
            throw NetworkError.notFound
        default:
            throw NetworkError.serverError(code: httpResponse.statusCode)
        }
    }
}
