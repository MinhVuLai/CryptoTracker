//
//  CoinDetailDataService.swift
//  CryptoTracker
//
//  Created by Minh Vu Lai on 7/17/24.
//

import Foundation
import Combine


final class CoinDetailDataService {
    
    @Published var coinDetails: CoinDetailModel? = nil
    
    private var coinDetailsSubscription: AnyCancellable?
    let coin: CoinModel
    
    
    init(coin: CoinModel) {
        self.coin = coin
        getCoinDetails()
    }
    
    
    func getCoinDetails() {
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false")
        else { return }
        
        coinDetailsSubscription = NetworkingManager.donwload(url: url)
            .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] returnedCoinDetails in
                self?.coinDetails = returnedCoinDetails
                self?.coinDetailsSubscription?.cancel()
            })
    }
    
}
