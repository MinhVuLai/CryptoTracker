//
//  CoinImageService.swift
//  CryptoTracker
//
//  Created by Minh Vu Lai on 7/14/24.
//

import SwiftUI
import Combine


final class CoinImageService {
    
    @Published var image: UIImage? = nil
    
    private let coin: CoinModel
    private var imageSubscription: AnyCancellable?
    
    
    init(coin: CoinModel) {
        self.coin = coin
        getCoinImage()
    }
    
    
    private func getCoinImage() {
        
        guard let url = URL(string: coin.image) else { return }
        
        imageSubscription = NetworkingManager.donwload(url: url)
            .tryMap({ data -> UIImage? in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] returnedImage in
                self?.image = returnedImage
                self?.imageSubscription?.cancel()
            })
    }
    
}
