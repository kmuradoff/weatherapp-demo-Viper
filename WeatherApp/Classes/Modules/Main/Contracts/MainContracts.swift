//
//  MainContracts.swift
//  WeatherApp
//
//  Created by Kamal Muradov on 17.10.2025
//  
//

import Foundation

protocol MainRouterProtocol: RouterProtocol {
    func openCityDetails(_ city: City)
}

protocol MainInteractorProtocol: InteractorProtocol {
    func searchCities(query: String) async throws -> [City]
}

protocol MainPresenterProtocol: PresenterProtocol {
    func onAppear()
    func onQueryChanged(_ query: String)
    func onCitySelected(_ city: City)
}

protocol MainViewStateProtocol: ViewStateProtocol, ObservableObject {
    var query: String { get set }
    var isLoading: Bool { get set }
    var error: String? { get set }
    var results: [City] { get set }
    func select(_ city: City)
}
