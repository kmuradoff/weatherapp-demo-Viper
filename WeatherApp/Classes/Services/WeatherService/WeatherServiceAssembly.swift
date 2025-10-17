import Foundation

final class WeatherServiceAssembly: Assembly {
    func build() -> WeatherServiceType {
        WeatherService()
    }
}
