//
//  UIScreen.swift
//  CryptoTracker
//
//  Created by Minh Vu Lai on 7/14/24.
//

import SwiftUI


extension UIScreen {
    static var current: UIScreen? {
        UIWindow.current?.screen
    }
}
