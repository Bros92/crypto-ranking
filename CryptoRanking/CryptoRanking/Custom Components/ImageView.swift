//
//  ImageView.swift
//  CryptoRanking
//
//  Created by Vincenzo Broscritto on 16/10/22.
//

import SwiftUI

struct ImageView: View {
    /// The
    @ObservedObject var imageLoader: ImageLoader
    @State var image = UIImage()

    init(url: String) {
        imageLoader = ImageLoader(url:url)
    }
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .onReceive(imageLoader.didChange) { data in
                self.image = UIImage(data: data) ?? UIImage()
            }
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(url: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579")
        ImageView(url: "https://assets.coingecko.com/coins/images/5/large/dogecoin.png?1547792256")
    }
}
