//
//  UIApplication.swift
//  CryptoTracker
//
//  Created by Minh Vu Lai on 7/14/24.
//

import SwiftUI


extension UIApplication {
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
