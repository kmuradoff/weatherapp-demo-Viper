//
//  MainInteractor.swift
//  WeatherApp
//
//  Created by Kamal Muradov on 17.10.2025
//  
//

import Foundation

final class CityDetailsInteractor: CityDetailsInteractorProtocol {
    private let weatherService: WeatherServiceType
    
    init(weatherService: WeatherServiceType) {
        self.weatherService = weatherService
    }
    
    func load(lat: Double, lon: Double, units: String) async throws -> (CurrentWeather, [ForecastItem]) {
        async let w = weatherService.currentWeather(lat: lat, lon: lon, units: units)
        async let f = weatherService.forecast(lat: lat, lon: lon, units: units)
        return try await (w, f)
    }
}

// MARK: Private
extension CityDetailsInteractor {
    
}
