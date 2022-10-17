//
//  CryptoRankingApp.swift
//  CryptoRanking
//
//  Created by Vincenzo Broscritto on 15/10/22.
//

import SwiftUI

@main
struct CryptoRankingApp: App {
    var body: some Scene {
        WindowGroup {
            CoinListView(viewModel: CoinListViewModel())
                .onAppear {
                    UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "OpenSans-Bold", size: 34)!, .foregroundColor: UIColor.white]
                    UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "OpenSans-Bold", size: 17)!, .foregroundColor: UIColor.white]
                }
        }
    }
}
