//
//  MainAssembly.swift
//  WeatherApp
//
//  Created by Kamal Muradov on 17.10.2025
//  
//


import SwiftUI

final class CityDetailsAssembly: Assembly {
    func build(city: City) -> some View {
        let navigationService = container.resolve(NavigationAssembly.self).build()
        let weatherService = container.resolve(WeatherServiceAssembly.self).build()
        
        let router = CityDetailsRouter(navigationService: navigationService)
        let interactor = CityDetailsInteractor(weatherService: weatherService)
        let viewState = CityDetailsViewState(city: city)
        let presenter = CityDetailsPresenter(router: router, interactor: interactor, viewState: viewState)
        viewState.set(with: presenter)
        
        return CityDetailsView(viewState: viewState)
    }
}
