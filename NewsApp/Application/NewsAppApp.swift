//
//  NewsAppApp.swift
//  NewsApp
//


import SwiftUI

@main
struct NewsAppApp: App {
    @StateObject var articleBookmarkVM = ArticleBookmarkViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(articleBookmarkVM)
        }
    }
}
