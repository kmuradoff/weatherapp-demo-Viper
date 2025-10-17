//
//  MainInteractor.swift
//  WeatherApp
//
//  Created by Kamal Muradov on 17.10.2025
//  
//

import Foundation

final class MainInteractor: MainInteractorProtocol {
    private let weatherService: WeatherServiceType
    
    init(weatherService: WeatherServiceType) {
        self.weatherService = weatherService
    }
    
    func searchCities(query: String) async throws -> [City] {
        try await weatherService.searchCities(query: query, limit: 10)
    }
}

// MARK: Private
extension MainInteractor {
    
}
