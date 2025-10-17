import Foundation

final class WeatherService: WeatherServiceType {
    private let session: URLSession
    private let decoder: JSONDecoder
    
    // TODO: Вставь свой API ключ OpenWeather (зарегистрируйся на https://openweathermap.org/api)
    private let apiKey: String = "7cb107e2dfe695add3b40134b9262d98"
    private let baseURL = URL(string: "https://api.openweathermap.org")!
    
    init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.decoder.dateDecodingStrategy = .secondsSince1970
    }
    
    func searchCities(query: String, limit: Int = 5) async throws -> [City] {
        var comps = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        comps?.path = "/geo/1.0/direct"
        comps?.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "appid", value: apiKey)
        ]
        guard let url = comps?.url else { throw URLError(.badURL) }
        
        let data = try await get(url: url)
        let dtos = try decoder.decode([GeocodeDTO].self, from: data)
        return dtos.map { City(name: $0.name, country: $0.country, lat: $0.lat, lon: $0.lon, state: $0.state) }
    }
    
    func currentWeather(lat: Double, lon: Double, units: String = "metric") async throws -> CurrentWeather {
        var comps = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        comps?.path = "/data/2.5/weather"
        comps?.queryItems = [
            URLQueryItem(name: "lat", value: "\(lat)"),
            URLQueryItem(name: "lon", value: "\(lon)"),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: units),
            URLQueryItem(name: "lang", value: "en")
        ]
        guard let url = comps?.url else { throw URLError(.badURL) }
        
        let data = try await get(url: url)
        let dto = try decoder.decode(CurrentWeatherDTO.self, from: data)
        let weather = dto.weather.first
        return CurrentWeather(
            cityName: dto.name,
            temperature: dto.main.temp,
            feelsLike: dto.main.feelsLike,
            humidity: dto.main.humidity,
            windSpeed: dto.wind.speed,
            descriptionText: weather?.description ?? "",
            icon: weather?.icon ?? "01d"
        )
    }
    
    func forecast(lat: Double, lon: Double, units: String = "metric") async throws -> [ForecastItem] {
        var comps = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        comps?.path = "/data/2.5/forecast"
        comps?.queryItems = [
            URLQueryItem(name: "lat", value: "\(lat)"),
            URLQueryItem(name: "lon", value: "\(lon)"),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: units),
            URLQueryItem(name: "lang", value: "en")
        ]
        guard let url = comps?.url else { throw URLError(.badURL) }
        
        let data = try await get(url: url)
        let dto = try decoder.decode(ForecastDTO.self, from: data)
        return dto.list.map { item in
            let weather = item.weather.first
            return ForecastItem(
                dt: Date(timeIntervalSince1970: TimeInterval(item.dt)),
                temperature: item.main.temp,
                tempMin: item.main.tempMin,
                tempMax: item.main.tempMax,
                descriptionText: weather?.description ?? "",
                icon: weather?.icon ?? "01d"
            )
        }
    }
    
    // MARK: - Network
    
    private func get(url: URL) async throws -> Data {
        let (data, response) = try await session.data(from: url)
        if let http = response as? HTTPURLResponse {
            print("[WeatherService] \(http.statusCode) \(url.absoluteString)")
            if !(200..<300).contains(http.statusCode) {
                if let body = String(data: data, encoding: .utf8) {
                    print("[WeatherService] Error body: \(body)")
                }
                throw URLError(.badServerResponse)
            }
        }
        return data
    }
}

// MARK: - DTOs

private struct GeocodeDTO: Codable {
    let name: String
    let lat: Double
    let lon: Double
    let country: String
    let state: String?
}

private struct CurrentWeatherDTO: Codable {
    struct Weather: Codable { let main: String; let description: String; let icon: String }
    struct Main: Codable { let temp: Double; let feelsLike: Double; let humidity: Int }
    struct Wind: Codable { let speed: Double }
    let name: String
    let weather: [Weather]
    let main: Main
    let wind: Wind
}

private struct ForecastDTO: Codable {
    struct Item: Codable {
        struct Main: Codable { let temp: Double; let tempMin: Double; let tempMax: Double }
        struct Weather: Codable { let description: String; let icon: String }
        let dt: Int
        let main: Main
        let weather: [Weather]
    }
    let list: [Item]
}
