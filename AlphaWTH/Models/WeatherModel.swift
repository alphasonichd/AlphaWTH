//
//  WeatherModel.swift
//  AlphaWTH
//
//  Created by developer on 21.02.21.
//

import Foundation


struct WeatherModel {
    
    let temp: Double
    let feelsLike: Double
    let description: String
    let conditionId: Int
    let dailyData: [DailyInfo]
    
    var temperatureString: String {
        return String(format: "%.1f", temp)
    }
    
    var feelsLikeString: String {
        return String(format: "%.1f", feelsLike)
    }
    
    static func systemIconName(for id: Int) -> String {
        switch id {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
}

struct LatLonData {
    let lon: Double
    let lat: Double
}

