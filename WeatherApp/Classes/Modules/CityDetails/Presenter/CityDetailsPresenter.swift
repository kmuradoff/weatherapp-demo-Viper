//
//  MainPresenter.swift
//  WeatherApp
//
//  Created by Kamal Muradov on 17.10.2025
//
//

import Foundation

final class CityDetailsPresenter: CityDetailsPresenterProtocol {
    private let router: CityDetailsRouterProtocol
    private let interactor: CityDetailsInteractorProtocol
    private unowned let viewState: CityDetailsViewState
    
    init(router: CityDetailsRouterProtocol,
         interactor: CityDetailsInteractorProtocol,
         viewState: CityDetailsViewState) {
        self.router = router
        self.interactor = interactor
        self.viewState = viewState
    }
    
    func onAppear() {
        Task { @MainActor in
            viewState.showLoading(true)
            do {
                let (w, f) = try await interactor.load(
                    lat: viewState.city.lat,
                    lon: viewState.city.lon,
                    units: "metric"
                )
                viewState.show(current: w, forecast: f)
                viewState.showLoading(false)
            } catch {
                viewState.showLoading(false)
                viewState.showError("Load failed: \(error.localizedDescription)")
            }
        }
    }
    
    func onClose() {
        router.close()
    }
}
