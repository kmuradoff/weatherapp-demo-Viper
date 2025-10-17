//
//  NavigationService.swift
//  WeatherApp
//
//  Created by Kamal Muradov on 17.10.2025
//
//

import SwiftUI
import Foundation
import Combine

public class NavigationService: NavigationServiceType  {
    
    public let id = UUID()
    
    public static func == (lhs: NavigationService, rhs: NavigationService) -> Bool {
        lhs.id == rhs.id
    }
    
    // Навигационное состояние
    @Published var modalView: Views?
    @Published var popupView: Views?
    @Published var items: [Views] = []
    @Published var alert: CustomAlert?
}

// Маршруты приложения
enum Views: Identifiable, Equatable, Hashable {
    case main
    case cityDetails(city: City)
    
    var id: String { stringKey }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.stringKey)
    }
    
    var stringKey: String {
        switch self {
        case .main:
            return "main"
        case .cityDetails(let city):
            // Учитываем город, чтобы идентификатор был уникален для разных городов
            return "cityDetails-\(city.id)"
        }
    }
}

// Алёрты навигации (по необходимости)
enum CustomAlert: Equatable, Hashable {
    static func == (lhs: CustomAlert, rhs: CustomAlert) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .defaultAlert:
            hasher.combine("defaultAlert")
        }
    }
    
    case defaultAlert(yesAction: (()->Void)?, noAction: (()->Void)?)
}
