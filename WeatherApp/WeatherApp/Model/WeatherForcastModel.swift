//
//  WeatherForcastModel.swift
//  WeatherApp
//
//  Created by Dereje Gudeta on 5/22/23.
//

import Foundation

struct WeatherForcastModel: Decodable {
    let cod: String
    let message, cnt: Int
    let list: [List]
    let city: City
}

struct City: Decodable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let population, timezone, sunrise, sunset: Int
}

struct Coord: Decodable {
    let lat, lon: Double
}

struct List: Decodable {
    let dt: Int
    let main: MainClass
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind

}

struct Clouds: Decodable {
    let all: Int
}

struct MainClass: Decodable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, seaLevel, grndLevel, humidity: Int
    let tempKf: Double

}


struct Weather: Decodable {
    let id: Int
    let icon: String
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double
}
