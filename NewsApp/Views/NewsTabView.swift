//
//  NewsTabView.swift
//  NewsApp
//


import SwiftUI

struct NewsTabView: View {
    @StateObject var articlesNewViewModel = ArticleNewsViewModel(newAPI: NewsAPIService())
    var body: some View {
        NavigationStack {
            ArticleListView(articles: articles)
                .overlay(content: overlayView)
                .task(id: articlesNewViewModel.token, loadTask)
                .navigationTitle(articlesNewViewModel.token.category.title)
                .navigationBarItems(trailing: menu)
        }
    }
    
    @ViewBuilder
    func overlayView() -> some View {
        switch articlesNewViewModel.state {
            case .loading:
                ProgressView()
            case .loaded(let articles) where articles.isEmpty:
            EmptyPlaceHolderView(text: AppConstants.emptyPlaceHolderViewArticlaText, image: nil)
            case .failure(let error):
                RetryView(text: error.localizedDescription) {
                    refreshTask()
                }
            default:
                EmptyView()
        }
    }
    
    private var articles: [Article] {
        if case let .loaded(articles) = articlesNewViewModel.state {
            return articles
        } else {
           return []
        }
    }
    
    @Sendable
    private func loadTask() async {
        await articlesNewViewModel.fetchNews()
    }
    
    private func refreshTask() {
        DispatchQueue.main.async {
            articlesNewViewModel.token = FetchNewsToken(
                category: articlesNewViewModel.token.category,
                token: Date.now
            )
        }
        
    }
    
    private var menu: some View {
        Menu {
            Picker("Category", selection: $articlesNewViewModel.token.category) {
                ForEach(Category.allCases) {
                    Text($0.title).tag($0)
                }
            }
        } label: {
            Image(systemName: "fiberchannel")
        }

    }
}

#Preview {
    NewsTabView(articlesNewViewModel: ArticleNewsViewModel(articles: Article.mockData))
        .environmentObject(ArticleBookmarkViewModel())
}
