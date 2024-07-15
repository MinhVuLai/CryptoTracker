//
//  HomeViewModel.swift
//  CryptoTracker
//
//  Created by Minh Vu Lai on 7/14/24.
//

import Foundation
import Combine


final class HomeViewModel: ObservableObject {
    
    @Published var statistics: [StatisticModel] = []
    
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    
    @Published var sortOption: SortOption = .holdings
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    
    private var cancellables = Set<AnyCancellable>()
    
    enum SortOption {
        case rank, rankReversed
        case holdings, holdingsReversed
        case price, priceReversed
    }
    
    
    init() {
        addSubscribers()
    }
    
    
    private func addSubscribers() {
//        coinDataService.$allCoins
//            .sink { [weak self] returnedCoins in
//                self?.allCoins = returnedCoins
//            }
//            .store(in: &cancellables)
        
        // updates allCoins
        $searchText
            .combineLatest(coinDataService.$allCoins, $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        // updates portfolioCoins
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] returnedCoins in
                guard let self else { return }
                self.portfolioCoins = self.sortPortfolioCoinsIfNeeded(coins: returnedCoins)
            }
            .store(in: &cancellables)
        
        // updates marketData
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
            .sink { [weak self] returnedStatistics in
                self?.statistics = returnedStatistics
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    
    func reloadData() {
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getMarketData()
        HapticManager.notificaion(type: .success)
    }
    
    
    private func filterAndSortCoins(text: String, coins: [CoinModel], sortOption: SortOption) -> [CoinModel] {
        var updatedCoins = filterCoins(text: text, coins: coins)
        sortCoins(sortOption: sortOption, coins: &updatedCoins)
        return updatedCoins
    }
    
    
    private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else { return coins }
        
        let lowercasedText = text.lowercased()
        
        return coins.filter { coin -> Bool in
            return coin.name.lowercased().contains(lowercasedText) ||
                    coin.symbol.lowercased().contains(lowercasedText) ||
                    coin.id.lowercased().contains(lowercasedText)
        }
    }
    
    
    private func sortCoins(sortOption: SortOption, coins: inout [CoinModel]) {
        switch sortOption {
        case .rank, .holdings:
            coins.sort(by: { $0.rank < $1.rank })
        case .rankReversed, .holdingsReversed:
            coins.sort(by: { $0.rank > $1.rank })
        case .price:
            coins.sort(by: { $0.currentPrice < $1.currentPrice })
        case .priceReversed:
            coins.sort(by: { $0.currentPrice > $1.currentPrice })
        }
    }
    
    
    private func sortPortfolioCoinsIfNeeded(coins: [CoinModel]) -> [CoinModel] {
        switch sortOption {
        case .holdings:
            return coins.sorted(by: { $0.currentHoldingsValue > $1.currentHoldingsValue })
        case .holdingsReversed:
            return coins.sorted(by: { $0.currentHoldingsValue < $1.currentHoldingsValue })
        default:
            return coins
        }
    }
    
    
    private func mapAllCoinsToPortfolioCoins(allCoins: [CoinModel], portfolioEntities: [PortfolioEntity]) -> [CoinModel] {
        allCoins
            .compactMap { (coin) -> CoinModel? in
                guard let entity = portfolioEntities.first(where: { $0.coinID == coin.id }) else {
                    return nil
                }
                return coin.updateHoldings(amount: entity.amount)
            }
    }
    
    
    private func mapGlobalMarketData(marketDataModel: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticModel] {
        var statistics: [StatisticModel] = []
        
        guard let data = marketDataModel else { return statistics }
        
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        
        let portfolioValue = portfolioCoins
            .map({ $0.currentHoldingsValue })
            .reduce(0, +)
        
        let previousValue = portfolioCoins
            .map { coin -> Double in
                let currentValue = coin.currentHoldingsValue
                let percentChange = (coin.priceChangePercentage24H ?? 0) / 100 // 25% -> 25 -> 0.25
                let previousValue = currentValue / (1 + percentChange)
                return previousValue
            }
            .reduce(0, +)
        
        let percentageChange = ((portfolioValue - previousValue) / previousValue) * 100
        
        let portfolio = StatisticModel(
            title: "Portfolio Value",
            value: portfolioValue.asCurrencyWith2Decimals(),
            percentageChange: percentageChange)
        
        statistics.append(contentsOf: [marketCap, volume, btcDominance, portfolio])
        return statistics
    }
    
}
