//
//  MainViewState.swift
//  WeatherApp
//
//  Created by Kamal Muradov on 17.10.2025
//
//

import Foundation
import Combine

final class CityDetailsViewState: ViewStateProtocol, ObservableObject {
    private var presenter: CityDetailsPresenterProtocol?
    
    @Published var city: City
    @Published var isLoading: Bool = false
    @Published var error: String?
    @Published var current: CurrentWeather?
    @Published var forecast: [ForecastItem] = []
    
    init(city: City) {
        self.city = city
    }
    
    func set(with presenter: any PresenterProtocol) {
        self.presenter = presenter as? CityDetailsPresenterProtocol
    }
    
    // Presenter -> View
    func showLoading(_ flag: Bool) { isLoading = flag }
    func showError(_ message: String) { error = message }
    func show(current: CurrentWeather, forecast: [ForecastItem]) {
        self.current = current
        self.forecast = forecast
    }
    
    // View -> Presenter
    func onAppear() { presenter?.onAppear() }
    func onClose() { presenter?.onClose() }
}
