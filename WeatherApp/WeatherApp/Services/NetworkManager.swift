//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Dereje Gudeta on 5/21/23.
//

import Foundation
import Combine

protocol NetworkFetcher{
    func requestDataModel<T:Decodable>(request:URLRequest?) -> AnyPublisher<T, NetworkError>
}

class NetworkManager{
    let session: URLSession
    let decoder: JSONDecoder
    init(session: URLSession = URLSession.shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.decoder = decoder
    }
}

extension NetworkManager:NetworkFetcher {
    func requestDataModel<T>(request: URLRequest?) -> AnyPublisher<T, NetworkError> where T : Decodable {
        guard let request = request else {
            return Fail(error: NetworkError.faultyRequest).eraseToAnyPublisher()
        }
        return self.session.dataTaskPublisher(for: request)
            .tryMap{(payload) in
                return payload.data
            }
            .decode(type: T.self, decoder: self.decoder)
            .mapError{ error in
                return NetworkError.other(error)
            }
            .eraseToAnyPublisher()
        
    }
}
