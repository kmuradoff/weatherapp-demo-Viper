//
//  RootApp.swift
//  WeatherApp
//
//  Created by Kamal Muradov on 17.10.2025
//  
//

import SwiftUI

@main
struct RootApp: App {
    
    @ObservedObject var appViewBuilder: ApplicationViewBuilder
    @ObservedObject var navigationService: NavigationService
    
    let container: DependencyContainer = {
        let factory = AssemblyFactory()
        let container = DependencyContainer(assemblyFactory: factory)
                
        // Services
        container.apply(NavigationAssembly.self)
        container.apply(WeatherServiceAssembly.self)
        container.apply(CityDetailsAssembly.self)
    
        // Modules
        container.apply(MainAssembly.self)

        return container
    }()

    init() {
        navigationService = container.resolve(NavigationAssembly.self).build() as! NavigationService
        
        appViewBuilder = ApplicationViewBuilder(container: container)
    }
    
    
    var body: some Scene {
        WindowGroup {
            RootView(navigationService: navigationService,
                     appViewBuilder: appViewBuilder)
        }
    }
    
    
}
