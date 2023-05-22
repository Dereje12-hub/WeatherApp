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
   
    //case dataNotFoundError
   // case APIError
   // case invalidURL
   // case parsingError
}

//NSLocalizedString used for any language, used for language translation
//
//extension NetworkError:LocalizedError{
//    var errorDescription: String?{
//        switch self{
//        case .faultyRequest:
//            return NSLocalizedString("Failed Request", comment: "FailedRequest")
//        case .dataNotFoundError:
//            return NSLocalizedString("Failed to get data from API", comment: "dataNotFoundError")
//            //        case .APIError:
//            //            return NSLocalizedString("API not responsing", comment: "APIError")
//            //        case .invalidURL:
//            //            return NSLocalizedString("Wrong API endpoint", comment: "APIError")
//            //        case .parsingError:
//            //            return NSLocalizedString("Failed to parse JSON", comment: "APIError")
//
//
//    }
//}
