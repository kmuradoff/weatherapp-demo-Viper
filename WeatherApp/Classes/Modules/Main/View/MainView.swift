//
//  MainView.swift
//  WeatherApp
//
//  Created by Kamal Muradov on 17.10.2025
//  
//

import SwiftUI

struct MainView: View {
    @ObservedObject var viewState: MainViewState

    var body: some View {
        List {
            if viewState.isLoading {
                HStack {
                    ProgressView()
                    Text("Searching…")
                }
            }
            if let error = viewState.error {
                Text(error).foregroundColor(.red)
            }
            ForEach(viewState.results) { city in
                Button {
                    viewState.select(city)
                } label: {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(city.name).font(.headline)
                        HStack(spacing: 6) {
                            Text(city.country)
                            if let s = city.state { Text("• \(s)") }
                        }
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Weather")
        .searchable(text: $viewState.query, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Search city")
    }
}

struct MainPreviews: PreviewProvider {
    static var previews: some View {
        ApplicationViewBuilder.stub.build(view: .main)
    }
}

