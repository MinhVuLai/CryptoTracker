//
//  DetailView.swift
//  CryptoTracker
//
//  Created by Minh Vu Lai on 7/17/24.
//

import SwiftUI


struct DetailLoadingView: View {
    
    @Binding var coin: CoinModel?
    
    
    var body: some View {
        ZStack {
            if let coin {
                DetailView(coin: coin)
            }
        }
    }
}


struct DetailView: View {
    
    let coin: CoinModel
    
    
    init(coin: CoinModel) {
        self.coin = coin
        print("INITILIZING DETAIL VIEW FOR: \(coin.name.uppercased())")
    }
    
    
    var body: some View {
        Text(coin.name)
    }
}


#Preview {
    DetailView(coin: PreviewSamples.coin)
}
