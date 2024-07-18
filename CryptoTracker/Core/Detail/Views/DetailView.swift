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
    
    @StateObject private var viewModel: DetailViewModel
    private let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
    private let spacing: CGFloat = 30
    
    
    init(coin: CoinModel) {
        _viewModel = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    
    
    var body: some View {
        ScrollView {
            VStack {
                ChartView(coin: viewModel.coin)
                    .padding(.vertical)
                
                VStack(spacing: 20) {
                    overviewSection
                    additionalSection
                }
                .padding()
            }
        }
        .navigationTitle(viewModel.coin.name)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                navigationBarTrailing
            }
        }
    }
}


extension DetailView {
    
    private var navigationBarTrailing: some View {
        HStack(spacing: 4) {
            Text(viewModel.coin.symbol.uppercased())
                .font(.headline)
                .foregroundStyle(Color.theme.secondaryText)
            
            CoinImageView(coin: viewModel.coin)
                .frame(width: 25, height: 25)
        }
    }
    
    
    private var overviewSection: some View {
        Group {
            Text("Overview")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(Color.theme.accent)
                .frame(maxWidth: .infinity, alignment: .leading)
            Divider()
            
            LazyVGrid(columns: columns,
                      alignment: .leading,
                      spacing: spacing) {
                ForEach(viewModel.overviewStatistics) { stat in
                    StatisticView(stat: stat)
                }
            }
        }
    }
    
    
    private var additionalSection: some View {
        Group {
            Text("Additional Details")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(Color.theme.accent)
                .frame(maxWidth: .infinity, alignment: .leading)
            Divider()
            
            LazyVGrid(columns: columns,
                      alignment: .leading,
                      spacing: spacing) {
                ForEach(viewModel.additionalStatistics) { stat in
                    StatisticView(stat: stat)
                }
            }
        }
    }
    
}


#Preview {
    NavigationStack {
        DetailView(coin: PreviewSamples.coin)
    }
}
