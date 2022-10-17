//
//  RankingPositionCard.swift
//  CryptoRanking
//
//  Created by Vincenzo Broscritto on 16/10/22.
//

import SwiftUI

struct RankingPositionCard: View {
    struct Model {
        var position: Int
        var name: String
        var hasBorder: Bool
        var imageURL: String
        var price: Double
    }
    /// The data to populate the view
    var model: Model
    var body: some View {
        ZStack {
            HStack {
                HStack(spacing: 0) {
                    Spacer()
                    // Overley is used to allow center the text of name of crypto
                        .overlay(
                            HStack {
                                Text("#\(model.position)")
                                    .font(.openSansRegular(size: 16))
                                    .foregroundColor(.black)
                                    .lineLimit(1)
                                    .fixedSize()
                                ImageView(url: model.imageURL)
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(25)
                                    .if(model.hasBorder, transform: { view in
                                        view.roundedEdge(radius: 25, edges: .allCorners, width: 1, color: .blue)
                                    })
                                Spacer()
                            }
                        )
                }
                Text(model.name)
                    .foregroundColor(.black)
                    .font(.openSansRegular(size: 21))
                HStack(spacing: 0) {
                    Spacer()
                        .overlay(
                            HStack {
                                Spacer()
                                Text(model.price.toCurrency())
                                    .font(.openSansRegular(size: 16))
                                    .foregroundColor(.black)
                                    .scaledToFill()
                                    .minimumScaleFactor(0.5)
                                    .lineLimit(1)
                            }
                        )
                    
                }
            }
            .frame(height: 50)
            .padding(10)
        }
        .background(
            Color.white
                .cornerRadius(20)
                .shadow(color: .white.opacity(0.7), radius: 5, x: 0, y: 0)
        )
        .padding(.horizontal)
    }
}

struct RankingPositionCard_Previews: PreviewProvider {
    static var previews: some View {
        RankingPositionCard(model: RankingPositionCard.Model(position: 1, name: "BitCoin", hasBorder: true, imageURL: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579", price: 19000.55))
        RankingPositionCard(model: RankingPositionCard.Model(position: 10, name: "Dogecoin", hasBorder: false, imageURL: "https://assets.coingecko.com/coins/images/5/large/dogecoin.png?1547792256", price: 0.060815))
    }
}
