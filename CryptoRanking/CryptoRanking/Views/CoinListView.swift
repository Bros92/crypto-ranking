//
//  CoinListView.swift
//  CryptoRanking
//
//  Created by Vincenzo Broscritto on 16/10/22.
//

import SwiftUI

struct CoinListView: View {

    @StateObject var viewModel: CoinListViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                RadialGradient(gradient: Gradient(colors: [.blue, .black]), center: .center, startRadius: 2, endRadius: 650)
                    .ignoresSafeArea()
                ScrollView {
                    ForEach(0..<viewModel.coinList.count, id: \.self) { index in
                        let coin = viewModel.coinList[index]
                        NavigationLink(
                            destination: CoinDetailView(detail: viewModel.selectedCoin),
                            isActive: $viewModel.shouldPresentDetail) {
                            RankingPositionCard(model: .init(position: coin.marketCapRank, name: coin.name, hasBorder: coin.marketCapRank <= 3, imageURL: coin.image, price: coin.currentPrice))
                                .padding(.vertical, 5)
                                // Allow to tap the cards only after the update of list from api call
                                .allowsHitTesting(!viewModel.shouldShimmer)
                                .onTapGesture {
                                    // Call api to get the detail of coin
                                    viewModel.getCoinDetail(for: coin.id)
                                }
                        }
                        // Allow to tap the cards only after the update of list from api call
                            .allowsHitTesting(!viewModel.shouldShimmer)
                            .shimmer(isActive: viewModel.shouldShimmer)
                    }
                }
                .padding(.top)
                .setNavigationTitle(title: "CRYPTO_RANKING".localized, displayMode: .automatic)
                .onAppear {
                    // Get the coin list
                    viewModel.getCoinList()
                }
            }
        }
        .accentColor(.white)
        .navigationViewStyle(StackNavigationViewStyle())
        .environmentObject(ShimmerConfig())
    }
}

struct CoinListView_Previews: PreviewProvider {
    static var previews: some View {
        CoinListView(viewModel: CoinListViewModel())
    }
}
