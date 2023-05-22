//
//  Weather.swift
//  WeatherApp
//
//  Created by Dereje Gudeta on 5/21/23.
//

import Foundation

struct WeatherModel: Decodable {
    let coord: Coordinates
    let weather: [WeatherInfo]
    let base: String
    let main: TemperatureModel
    let visibility: Int
    let wind: WindModel
    let clouds: CloudModel
    let dt: Int64
    let sys: SysModel
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}

struct Coordinates: Decodable {
    let lon: Double
    let lat: Double
}

struct WeatherInfo: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct TemperatureModel: Decodable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let humidity: Int
    let seaLevel: Int?
    let grndLevel: Int?
}

struct WindModel: Decodable {
    let speed: Double
    let deg: Int
    let gust: Double?
}

struct CloudModel: Decodable {
    let all: Int
}

struct SysModel: Decodable {
    let type: Int
    let id: Int
    let country: String
    let sunrise: Int64
    let sunset: Int64
}
