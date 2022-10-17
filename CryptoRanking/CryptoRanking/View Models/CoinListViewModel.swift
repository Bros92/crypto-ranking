//
//  CoinListViewModel.swift
//  CryptoRanking
//
//  Created by Vincenzo Broscritto on 15/10/22.
//

import Combine
import Foundation

class CoinListViewModel: ObservableObject {
    /// A list of coin for ranking
    /// Are initially mocked to create the shimmer effect
    @Published var coinList: [Coin] = [
        Coin(id: "bitcoin", name: "BitCoin", image: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579", currentPrice: 20000, marketCapRank: 4),
        Coin(id: "bitcoin", name: "BitCoin", image: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579", currentPrice: 20000, marketCapRank: 4),
        Coin(id: "bitcoin", name: "BitCoin", image: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579", currentPrice: 20000, marketCapRank: 4),
        Coin(id: "bitcoin", name: "BitCoin", image: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579", currentPrice: 20000, marketCapRank: 4),
        Coin(id: "bitcoin", name: "BitCoin", image: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579", currentPrice: 20000, marketCapRank: 4),
        Coin(id: "bitcoin", name: "BitCoin", image: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579", currentPrice: 20000, marketCapRank: 4),
        Coin(id: "bitcoin", name: "BitCoin", image: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579", currentPrice: 20000, marketCapRank: 4),
        Coin(id: "bitcoin", name: "BitCoin", image: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579", currentPrice: 20000, marketCapRank: 4),
        Coin(id: "bitcoin", name: "BitCoin", image: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579", currentPrice: 20000, marketCapRank: 4),
        Coin(id: "bitcoin", name: "BitCoin", image: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579", currentPrice: 20000, marketCapRank: 4),
    ]
    /// A boolean to indicate if the the loader has been added
    @Published var shouldShimmer = true
    /// A boolean to indicat if the detail of coin can be present
    @Published var shouldPresentDetail = false
    /// The number of coins for ranking
    let limit = 10
    var selectedCoin: CoinDetail?
    /// Allow to cancel publisher
    private var cancellables = Set<AnyCancellable>()
    
    deinit {
        cancellables.forEach({ $0.cancel() })
    }
    
    /// Retrieve a list of coins order by market cap rank
    func getCoinList() {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let endpoint = APICoins.getTopCoins(currency: Currency.euro.rawValue, limit: limit, page: 1)
        API.coingecko.makeRequest([Coin].self, at: endpoint, with: decoder)
            .sink { result in
                switch result {
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                default: break
                }
            } receiveValue: { [weak self] coinList in
                self?.coinList = coinList
                self?.shouldShimmer = false
            }
            .store(in: &cancellables)

    }
    
    /// Retrive all detailed info for a coin
    /// - Parameter id: The id of the coin
    func getCoinDetail(for id: String) {
        let endpoint = APICoins.getCoinDetail(id: id)
        API.coingecko.makeRequest(CoinDetail.self, at: endpoint)
            .sink { result in
                switch result {
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                default: break
                }
            } receiveValue: { [weak self] detail in
                self?.selectedCoin = detail
                self?.shouldPresentDetail = true
            }
            .store(in: &cancellables)
    }
}
