//
//  API.swift
//  CryptoRanking
//
//  Created by Vincenzo Broscritto on 15/10/22.
//

import Combine
import Foundation

/// The HTTP methods for api request
enum HTTPMethods: String {
    case get
    case post
    case delete
    case put
}

protocol Endpoint {
    /// The path of api url
    var path: String { get }
    /// The HTTP method for the request
    var method: HTTPMethods { get }
    /// Create the request with header and body parameters
    /// - Returns: The api url request
    func asURLRequest(baseURL: String) throws -> URLRequest
}

/// Indicate the kind of error during api request
enum APIError: Error {
    case decodingError
    case httpError(Int)
    case genericError(Error?)
    case invalidUrl
}

struct API {
    /// The base url of API
    private var baseUrl: String
    
    /// Create API requests
    /// - Returns: Publisher with decoded response
    func makeRequest<T: Codable>(_ type: T.Type, at endpoint: Endpoint, with decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<T, APIError> {
        do {
            let request = try endpoint.asURLRequest(baseURL: self.baseUrl)
            return URLSession.shared
                .dataTaskPublisher(for: request)
                .receive(on: DispatchQueue.main)
                .mapError { error in
                    .genericError(error)
                }
                .flatMap { data, response -> AnyPublisher<T, APIError> in
                    if let response = response as? HTTPURLResponse {
                        debugPrint(String(data: data, encoding: .utf8) as Any)
                        // Return an http error if error code are thrown
                        if !(200...299).contains(response.statusCode) {
                            return Fail(error: APIError.httpError(response.statusCode))
                                .eraseToAnyPublisher()
                        } else {
                            // Decode response and emit output to subscriber
                            return Just(data)
                                .decode(type: T.self, decoder: decoder)
                                .tryMap { decoded in
                                    return decoded
                                }
                                .mapError({ _ in
                                            APIError.decodingError
                                    
                                })
                                .eraseToAnyPublisher()
                        }
                    } else {
                        return Fail(error: APIError.genericError(nil))
                            .eraseToAnyPublisher()
                    }
                }
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: APIError.invalidUrl)
                .eraseToAnyPublisher()
        }

    }

}

extension API {
    static let coingecko = API(baseUrl: "https://api.coingecko.com/api/v3")
    static var api: API {
        #if DEBUG
        return API.coingecko
        #else
        // There isn't a different base url for production
        return API.coingecko
        #endif
    }
}
