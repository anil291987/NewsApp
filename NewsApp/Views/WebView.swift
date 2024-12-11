//
//  WebView.swift
//  NewsApp
//

import SwiftUI
import SafariServices

struct WebView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        // update
    }
}

#Preview {
    WebView(url: URL(string: "https://ekonomika.sme.sk/c/22690875/tesla-stahuje-v-cine-zhruba-285-tisic-elektromobilov-pre-chybu-s-tempomatmi.html")!)
}
