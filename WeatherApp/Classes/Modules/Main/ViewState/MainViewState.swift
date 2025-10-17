//
//  MainViewState.swift
//  WeatherApp
//
//  Created by Kamal Muradov on 17.10.2025
//  
//

import SwiftUI

final class MainViewState: ObservableObject, MainViewStateProtocol {    
    private let id = UUID()
    private var presenter: MainPresenterProtocol?
    
    func set(with presener: MainPresenterProtocol) {
        self.presenter = presener
    }
}
