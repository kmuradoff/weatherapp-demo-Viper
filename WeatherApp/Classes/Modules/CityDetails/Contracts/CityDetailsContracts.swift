//
//  MainContracts.swift
//  WeatherApp
//
//  Created by Kamal Muradov on 17.10.2025
//  
//

import Foundation

protocol CityDetailsRouterProtocol: RouterProtocol {
    func close()
}

protocol CityDetailsInteractorProtocol: InteractorProtocol {
    func load(lat: Double, lon: Double, units: String) async throws -> (CurrentWeather, [ForecastItem])
}

protocol CityDetailsPresenterProtocol: PresenterProtocol {
    func onAppear()
    func onClose()
}
