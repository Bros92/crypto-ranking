//
//  ImageLoader.swift
//  CryptoRanking
//
//  Created by Vincenzo Broscritto on 16/10/22.
//

import Combine
import SwiftUI

class ImageLoader: ObservableObject {
    /// Broadcast image to subscribers
    var didChange = PassthroughSubject<Data, Never>()
    var data = Data() {
        didSet {
            // Update the data to send to listener
            didChange.send(data)
        }
    }

    init(url: String) {
        // Download the image at url
        guard let url = URL(string: url) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async { [weak self] in
                self?.data = data
            }
        }
        task.resume()
    }
}
