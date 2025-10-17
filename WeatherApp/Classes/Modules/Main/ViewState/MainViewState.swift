//
//  MainViewState.swift
//  WeatherApp
//
//  Created by Kamal Muradov on 17.10.2025
//
//

import Foundation
import Combine

final class MainViewState: MainViewStateProtocol {
    private var presenter: MainPresenterProtocol?
    private var cancellables = Set<AnyCancellable>()

    @Published var query: String = ""
    @Published var isLoading: Bool = false
    @Published var error: String?
    @Published var results: [City] = []

    func set(with presenter: any PresenterProtocol) {
        self.presenter = presenter as? MainPresenterProtocol
        bindQuery()
    }

    private func bindQuery() {
        $query
            .removeDuplicates()
            .debounce(for: .milliseconds(250), scheduler: DispatchQueue.main)
            .sink { [weak self] value in
                print("[Search] query changed -> '\(value)'") // лог
                self?.presenter?.onQueryChanged(value)
            }
            .store(in: &cancellables)
    }

    func select(_ city: City) {
        presenter?.onCitySelected(city)
    }
}
