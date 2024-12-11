//
//  EmptyPlaceHolderView.swift
//  NewsApp
//

import SwiftUI

struct RetryView: View {
    let text: String
    let retryAction: () -> Void
    var body: some View {
        VStack(spacing: 8) {
            Text(text)
                .font(.callout)
                .multilineTextAlignment(.center)
            
            Button(action: retryAction) {
                Text("Try again")
            }
        }
    }
}
