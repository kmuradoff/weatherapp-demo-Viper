//
//  MainAssembly.swift
//  WeatherApp
//
//  Created by Kamal Muradov on 17.10.2025
//  
//


import SwiftUI

final class MainAssembly: Assembly {
    func build() -> some View {
        let navigationService = container.resolve(NavigationAssembly.self).build()
        let weatherService = container.resolve(WeatherServiceAssembly.self).build()

        let router = MainRouter(navigationService: navigationService)
        let interactor = MainInteractor(weatherService: weatherService)
        let viewState = MainViewState()
        let presenter = MainPresenter(router: router, interactor: interactor, viewState: viewState)
        viewState.set(with: presenter) // важно!

        return MainView(viewState: viewState)
    }
}
