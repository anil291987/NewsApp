//
//  ContentView.swift
//  NewsApp
//


import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NewsTabView()
                .tabItem {
                    Label("News", systemImage: "newspaper")
                }
            BookMarkTabView()
                .tabItem {
                    Label("Bookmarks", systemImage: "bookmark")
                }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(ArticleBookmarkViewModel())
}
