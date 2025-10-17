//
//  ApplicationViewBuilder.swift
//  WeatherApp
//
//  Created by Kamal Muradov on 17.10.2025
//
//

import SwiftUI
import Foundation
import Combine

final class ApplicationViewBuilder : Assembly, ObservableObject {
    
    required init(container: Container) {
        super.init(container: container)
    }
   
    @ViewBuilder
    func build(view: Views) -> some View {
        switch view {
        case .main:
            buildMain()
        case .cityDetails(let city):
            buildCityDetails(city: city)
        }
    }
    
    @ViewBuilder
    fileprivate func buildMain() -> some View {
        container.resolve(MainAssembly.self).build()
    }
    
    @ViewBuilder
    fileprivate func buildCityDetails(city: City) -> some View {
        container.resolve(CityDetailsAssembly.self).build(city: city)
    }
}

extension ApplicationViewBuilder {
    static var stub: ApplicationViewBuilder {
        return ApplicationViewBuilder(
            container: RootApp().container
        )
    }
}
