//
//  XMarkButton.swift
//  CryptoTracker
//
//  Created by Minh Vu Lai on 7/14/24.
//

import SwiftUI


struct XMarkButton: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var viewModel: HomeViewModel
    
    var body: some View {
        Button {
            dismiss()
            viewModel.searchText = ""
        } label: {
            Image(systemName: "xmark")
                .font(.headline)
        }
    }
}


#Preview {
    XMarkButton()
        .environmentObject(PreviewSamples.homeViewModel)
}
