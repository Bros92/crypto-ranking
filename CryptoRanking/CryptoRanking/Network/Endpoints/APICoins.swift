//
//  APICoins.swift
//  CryptoRanking
//
//  Created by Vincenzo Broscritto on 15/10/22.
//

import Foundation

enum APICoins: Endpoint {
    case getTopCoins(currency: String, limit: Int, page: Int)
    case getCoinDetail(id: String)
    /// The path of endpoint
    var path: String {
        switch self {
        case .getTopCoins:
            return "/coins/markets"
        case .getCoinDetail(let id):
            return "/coins/\(id)"
        }
    }
    /// The http method for characters api requests
    var method: HTTPMethods {
        switch self {
        case .getTopCoins, .getCoinDetail:
            return .get
        }
    }
    
    /// Create an URL Request from request data.
    /// - Parameter baseURL: The base url for marvel api.
    /// - Returns: The url with header and body
    func asURLRequest(baseURL: String) throws -> URLRequest {
        let url = URL(string: baseURL)!
        var request = URLRequest(url: url.appendingPathComponent(self.path))
        request.httpMethod = self.method.rawValue.uppercased()
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        switch self {
        case .getTopCoins(let currency, let limit, let page):
            let body: [String: Any] = ["vs_currency": currency, "per_page": limit, "page": page]
            request.appendGETParameters([body])
        case .getCoinDetail:
            let body = ["sparkline": true]
            request.appendGETParameters([body])
        }
        return request
    }
}
