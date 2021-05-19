//
//  WeatherModelJSON.swift
//  AlphaWTH
//
//  Created by developer on 21.02.21.
//

import Foundation


struct WeatherDataJSON: Codable {
    let current: Current
    let daily: [DailyInfo]
}

struct Current: Codable {
    let temp: Double
    let feels_like: Double
    let weather: [Weather]
}

struct Weather: Codable {
    let id: Int
    let description: String
}

struct DailyInfo: Codable {
    let dt: Int
    let temp: DailyTemp
    let feels_like: DailyFeelsLike
    let weather: [Weather]
}

struct DailyTemp: Codable {
    let day: Double
    let night: Double
}

struct DailyFeelsLike: Codable {
    let day: Double
    let night: Double
}

//--------------------

struct LatLonJSON: Codable {
    let coord: Coordinates
}

struct Coordinates: Codable {
    let lon: Double
    let lat: Double
}
