//
//  Coin.swift
//  CryptoRanking
//
//  Created by Vincenzo Broscritto on 15/10/22.
//

import Foundation

struct Coin: Codable {
    
    var id: String
    var name: String
    var image: String
    var currentPrice: Double
    var marketCapRank: Int
}
