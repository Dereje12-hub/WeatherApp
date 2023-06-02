//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Dereje Gudeta on 5/21/23.
//

import Foundation
import UIKit
import Combine


protocol RefreshUIProtocol {
    func refreshMyUIScreen()
}

@MainActor
class WeatherViewModel {
    var weatherList: [WeatherModel] = [] {
        didSet{
            //refreshUI?()
            delegate?.refreshMyUIScreen()
        }
    }
    //*
    var weeklyWeatherList: [WeatherForcastModel] = [] {
        didSet{
            //refreshUI?()
            delegate?.refreshMyUIScreen()
        }
    }  //*/
    
    var isError: Bool = false
    
    //object of protocol
    var delegate: RefreshUIProtocol?
    
    //var networkFetcher: NetworkFetcher
    let networkFetcher: NetworkFetcher = NetworkManager()
    //Cancellabel object to cancel the whole operatin
    //
    private var cancellable = Set<AnyCancellable>()
    
    
    func getWeatherByCityName(cityName: String) {
       
        Task{
            print("getWeatherByCityName cityName = \(cityName)")
    
            //let networkFetcher: NetworkFetcher = NetworkManager()
            guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=8ae49103ffc6fe8e995b68bbe8626c77") else { return }
            let request = URLRequest(url: url)
            
            self.networkFetcher.requestDataModel(request: request)
                .receive(on: DispatchQueue.main)
                .sink { completion in //error in
                                      //print(error
                    switch completion {
                    case .finished:
                        print("Task is done!")
                    case .failure(let error):
                        print(error.localizedDescription)
                        self.isError = true
                        break
                    }
                } receiveValue: { (model: WeatherModel) in
                    
                    //print(model)
                    self.weatherList = [model]
                    
                }.store(in: &self.cancellable)
        }
        
    }

    
  
    func getWeatherByLocation(lat: Double, lon: Double) {
       
        Task{
            print("getWeatherByLocation  lat= \(lat)  lon= \(lon) ")
            
            guard let url = URL(string:"https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=8ae49103ffc6fe8e995b68bbe8626c77")
            else { return }
            
            let request = URLRequest(url: url)
            
            self.networkFetcher.requestDataModel(request: request)
                .receive(on: DispatchQueue.main)
                .sink { completion in //error in
                                      //print(error
                    switch completion {
                    case .finished:
                        print("Task is done!")
                    case .failure(let error):
                        print(error.localizedDescription)
                        self.isError = true
                        break
                    }
                } receiveValue: { (model: WeatherModel) in
                    
                    //print(model)
                    self.weatherList = [model]
                   
                }.store(in: &self.cancellable)
        }
        
    }
    
    
    func getWeeklyWeatherByLocation(lat: Double, lon: Double) {

        Task{
            //guard let url = URL(string:"http://api.openweathermap.org/data/2.5/forecast?lat=37.33233141&lon=-122.0312186&appid=8ae49103ffc6fe8e995b68bbe8626c77") else { return }
            guard let url = URL(string:"https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=8ae49103ffc6fe8e995b68bbe8626c77") else { return }
            let request = URLRequest(url: url)

            self.networkFetcher.requestDataModel(request: request)
                .receive(on: DispatchQueue.main)
                .sink { completion in //error in
                                      //print(error
                    switch completion {
                    case .finished:
                        print("Task is done!")
                    case .failure(let error):
                        print(error.localizedDescription)
                        self.isError = true
                        break
                    }
                } receiveValue: { (modelForcast: WeatherForcastModel) in

                    //print(modelForcast)
                    self.weeklyWeatherList = [modelForcast]
                   
                }.store(in: &self.cancellable)
        }

    }
    
    
    
}

