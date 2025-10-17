//
//  MainRouter.swift
//  WeatherApp
//
//  Created by Kamal Muradov on 17.10.2025
//  
//

import Foundation

final class CityDetailsRouter: CityDetailsRouterProtocol {
    var navigationService: any NavigationServiceType
    
    init(navigationService: any NavigationServiceType) {
        self.navigationService = navigationService
    }
    
    func close() {
        if !navigationService.items.isEmpty {
            navigationService.items.removeLast()
        }
    }
}
