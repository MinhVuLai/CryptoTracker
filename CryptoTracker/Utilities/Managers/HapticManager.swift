//
//  HapticManager.swift
//  CryptoTracker
//
//  Created by Minh Vu Lai on 7/15/24.
//

import SwiftUI


final class HapticManager {
    
    static private let generator = UINotificationFeedbackGenerator()
    
    static func notificaion(type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
    
}
