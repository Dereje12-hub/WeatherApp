//
//  NetworkError.swift
//  WeatherApp
//
//  Created by Dereje Gudeta on 5/21/23.
//

import Foundation


enum NetworkError:Error {
    case faultyRequest
    case other(Error)
}

