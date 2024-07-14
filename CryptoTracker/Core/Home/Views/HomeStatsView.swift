//
//  HomeStatsView.swift
//  CryptoTracker
//
//  Created by Minh Vu Lai on 7/14/24.
//

import SwiftUI


struct HomeStatsView: View {
    
    @EnvironmentObject private var viewModel: HomeViewModel
    @Binding var showPortfolio: Bool
    
    var body: some View {
        HStack {
            ForEach(viewModel.statistics) { stat in
                StatisticView(stat: stat)
                    .frame(width: Double(UIScreen.current?.bounds.size.width ?? 0) / 3)
            }
        }
        .frame(width: UIScreen.current?.bounds.size.width, alignment: showPortfolio ? .trailing : .leading)
    }
}


#Preview {
    HomeStatsView(showPortfolio: .constant(true))
        .environmentObject(PreviewSamples.homeViewModel)
}
