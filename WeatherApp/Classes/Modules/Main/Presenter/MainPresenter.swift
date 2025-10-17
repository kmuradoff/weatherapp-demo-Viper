//
//  MainPresenter.swift
//  WeatherApp
//
//  Created by Kamal Muradov on 17.10.2025
//
//

import Foundation

final class MainPresenter: MainPresenterProtocol {
    private let router: MainRouterProtocol
    private let interactor: MainInteractorProtocol
    private unowned let viewState: MainViewState

    init(router: MainRouterProtocol, interactor: MainInteractorProtocol, viewState: MainViewState) {
        self.router = router
        self.interactor = interactor
        self.viewState = viewState
    }

    func onAppear() {}

    func onQueryChanged(_ query: String) {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            viewState.results = []
            return
        }

        Task { @MainActor in
            viewState.isLoading = true
            viewState.error = nil
            do {
                let items = try await interactor.searchCities(query: trimmed)
                print("[Search] results count: \(items.count)")
                viewState.results = items
                viewState.isLoading = false
            } catch {
                print("[Search] error: \(error)")
                viewState.isLoading = false
                viewState.error = "Search failed: \(error.localizedDescription)"
            }
        }
    }

    func onCitySelected(_ city: City) {
        router.openCityDetails(city)
    }
}
