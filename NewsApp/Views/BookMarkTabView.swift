//
//  BookMarkTabView.swift
//  NewsApp
//


import SwiftUI

struct BookMarkTabView: View {
    @EnvironmentObject var articleBookmarkViewModel: ArticleBookmarkViewModel
    
    @State var searchText: String = ""
    @State private var searchScope = Category.general

    var body: some View {
        NavigationStack {
            ArticleListView(articles: articles)
                .overlay(overlayView(isEmpty: articles.isEmpty))
                .navigationTitle(AppConstants.bookmarkViewTitle)
        }
        .searchable(text: $searchText, prompt: Text(AppConstants.bookmarkViewSerachPlaceholder))
    }
    
    @ViewBuilder
    private func overlayView(isEmpty: Bool) -> some View {
        if isEmpty {
            EmptyPlaceHolderView(text: AppConstants.emptyPlaceHolderViewBookmarkText, image: AppConstants.emptyPlaceHolderViewSearchImage)
        }
    }
    
    private var articles: [Article] {
        articleBookmarkViewModel.filteredBookmarks(searchText)
    }
}

#Preview {
    BookMarkTabView()
        .environmentObject(ArticleBookmarkViewModel())
}
