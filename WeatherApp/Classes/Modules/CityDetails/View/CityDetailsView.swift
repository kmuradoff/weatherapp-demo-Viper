//
//  MainView.swift
//  WeatherApp
//
//  Created by Kamal Muradov on 17.10.2025
//  
//

import SwiftUI

private func iconURL(_ code: String) -> URL? {
    URL(string: "https://openweathermap.org/img/wn/\(code)@2x.png")
}

struct CityDetailsView: View {
    @ObservedObject var viewState: CityDetailsViewState
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                header
                if let current = viewState.current {
                    currentSection(current)
                }
                forecastSection
            }
            .padding()
        }
        .navigationTitle(viewState.city.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Close") { viewState.onClose() }
            }
        }
        .overlay {
            if viewState.isLoading { ProgressView().controlSize(.large) }
        }
        .alert("Error", isPresented: .constant(viewState.error != nil)) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewState.error ?? "")
        }
        .onAppear { viewState.onAppear() }
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(viewState.city.name).font(.largeTitle).bold()
            HStack {
                Text(viewState.city.country)
                if let st = viewState.city.state { Text("• \(st)") }
            }
            .foregroundColor(.secondary)
        }
    }
    
    private func currentSection(_ w: CurrentWeather) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center) {
                if let url = iconURL(w.icon) {
                    AsyncImage(url: url) { img in img.resizable().scaledToFit() } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 60, height: 60)
                }
                VStack(alignment: .leading) {
                    Text("\(Int(w.temperature.rounded()))°")
                        .font(.system(size: 48, weight: .bold))
                    Text(w.descriptionText.capitalized)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            HStack {
                Label("Feels \(Int(w.feelsLike.rounded()))°", systemImage: "thermometer")
                Spacer()
                Label("\(w.humidity)%", systemImage: "humidity")
                Spacer()
                Label("\(String(format: "%.1f", w.windSpeed)) m/s", systemImage: "wind")
            }
            .font(.subheadline)
        }
        .padding()
        .background(.ultraThickMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
    
    private var forecastSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Forecast (5-day / 3h)").font(.headline)
            ForEach(viewState.forecast) { item in
                HStack {
                    Text(item.dt, style: .date)
                    Text(item.dt, style: .time).foregroundColor(.secondary)
                    Spacer()
                    if let url = iconURL(item.icon) {
                        AsyncImage(url: url) { img in img.resizable().scaledToFit() } placeholder: {
                            Color.clear.frame(width: 30, height: 30)
                        }
                        .frame(width: 30, height: 30)
                    }
                    Text("\(Int(item.temperature.rounded()))°").frame(width: 44, alignment: .trailing)
                }
                .padding(.vertical, 4)
                Divider()
            }
        }
    }
}

struct CityDetailsViewPreviews: PreviewProvider {
    static var previews: some View {
        ApplicationViewBuilder.stub.build(view: .main)
    }
}

