//
//  RequestHandler.swift
//  AlphaWTH
//
//  Created by developer on 21.02.21.
//

import Foundation

final class NetworkService {
    
    private let endPoint = "https://api.openweathermap.org/data/2.5/"
    private let appId = "b4cd5c773a84a6d0457a56c06316ed0a"
    
    private struct NetworkError {
        static let badURL = NSError(domain: "NetworkService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Bad URL"])
        static let somethingWentWrong = NSError(domain: "NetworkService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Oops..something went wrong."])
    }
    
    func getWeather(for city: String, completion: @escaping (_ response: WeatherModel?, _ error: Error?) -> Void) {
        fetchLocation(for: city) { [weak self] (locationData, error) in
            guard let locationData = locationData, error == nil else {
                completion(nil, NetworkError.somethingWentWrong)
                return
            }
            self?.fetchWeather(for: locationData.lat, lon: locationData.lon) { weatherModel, error in
                guard let weatherModel = weatherModel, error == nil else {
                    completion(nil, NetworkError.somethingWentWrong)
                    return
                }
                completion(weatherModel, nil)
            }
        }
    }
    
    private func fetchLocation(for city: String, completion: @escaping (_ response: LatLonData?, _ error: Error?) -> Void) {
        guard let url = URL(string: "\(endPoint)weather?appid=\(appId)&q=\(city)") else {
            completion(nil, NetworkError.badURL)
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self, let data = data, let locationData = self.parseLatLonJSON(data), error == nil else {
                completion(nil, NetworkError.somethingWentWrong)
                return
            }
            completion(locationData, nil)
        }
        task.resume()
    }
    
    private func fetchWeather(for lat: Double, lon: Double, completion: @escaping (_ response: WeatherModel?, _ error: Error?) -> Void) {
        guard let url = URL(string: "\(endPoint)onecall?appid=\(appId)&lat=\(lat)&lon=\(lon)&exclude=minutely,hourly,alerts&units=metric") else {
            completion(nil, NetworkError.badURL)
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self, let data = data, let weatherModel = self.parseJSON(data), error == nil else {
                completion(nil, NetworkError.somethingWentWrong)
                return
            }
            completion(weatherModel, nil)
        }
        task.resume()
    }
    
    func parseLatLonJSON(_ latLonData: Data) -> LatLonData? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(LatLonJSON.self, from: latLonData)
            let lat = decodedData.coord.lat
            let lon = decodedData.coord.lon
            return LatLonData(lon: lon, lat: lat)
        } catch {
            return nil
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherDataJSON.self, from: weatherData)
            let temp = decodedData.current.temp
            let feelsLike = decodedData.current.feels_like
            let conditionId = decodedData.current.weather[0].id
            let description = decodedData.current.weather[0].description
            let dailyData = decodedData.daily
            let weather = WeatherModel(temp: temp, feelsLike: feelsLike, description: description, conditionId: conditionId, dailyData: dailyData)
            return weather
        } catch {
//            delegate?.didGetError(error: error)
            return nil
        }
    }
}
