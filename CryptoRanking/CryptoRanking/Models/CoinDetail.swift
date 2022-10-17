//
//  CoinDetail.swift
//  CryptoRanking
//
//  Created by Vincenzo Broscritto on 15/10/22.
//

import Foundation

struct CoinDetail: Codable {
    
    var description: Description
    var links: WebSite
    var marketData: MarketData
    var name: String
}

extension CoinDetail {
    enum CoinDetailKeys: String, CodingKey {
        case description, links, name
        case marketData = "market_data"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CoinDetailKeys.self)
        self.marketData = try container.decode(MarketData.self, forKey: .marketData)
        self.description = try container.decode(Description.self, forKey: .description)
        self.links = try container.decode(WebSite.self, forKey: .links)
        self.name = try container.decode(String.self, forKey: .name)
    }
}
