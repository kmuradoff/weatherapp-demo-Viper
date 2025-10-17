import Foundation

public struct City: Identifiable, Equatable, Hashable, Codable {
    public var id: String { "\(name)-\(country)-\(lat)-\(lon)" }
    public let name: String
    public let country: String
    public let lat: Double
    public let lon: Double
    public let state: String?
}

public struct CurrentWeather: Equatable, Hashable, Codable {
    public let cityName: String
    public let temperature: Double
    public let feelsLike: Double
    public let humidity: Int
    public let windSpeed: Double
    public let descriptionText: String
    public let icon: String
}

public struct ForecastItem: Identifiable, Equatable, Hashable, Codable {
    public var id: String { "\(dt.timeIntervalSince1970)-\(icon)" }
    public let dt: Date
    public let temperature: Double
    public let tempMin: Double
    public let tempMax: Double
    public let descriptionText: String
    public let icon: String
}

public protocol WeatherServiceType {
    func searchCities(query: String, limit: Int) async throws -> [City]
    func currentWeather(lat: Double, lon: Double, units: String) async throws -> CurrentWeather
    func forecast(lat: Double, lon: Double, units: String) async throws -> [ForecastItem]
}
