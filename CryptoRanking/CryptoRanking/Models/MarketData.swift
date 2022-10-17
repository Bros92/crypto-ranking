//
//  MarketData.swift
//  CryptoRanking
//
//  Created by Vincenzo Broscritto on 16/10/22.
//

import Foundation

struct MarketData: Codable {
    var sparkline: Sparkline
    var lastUpdated: String
}

extension MarketData {
    
    enum MarketDataKeys: String, CodingKey {
        case sparkline = "sparkline_7d"
        case lastUpdated = "last_updated"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MarketDataKeys.self)
        self.sparkline = try container.decode(Sparkline.self, forKey: .sparkline)
        self.lastUpdated = try container.decode(String.self, forKey: .lastUpdated)
    }
}
