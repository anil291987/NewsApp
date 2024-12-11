//
//  ArticleNewsViewModel.swift
//  NewsApp
//


import Combine
import Foundation

enum CustomError: Error, Equatable {
    case someError(String)
    
    static func == (lhs: CustomError, rhs: CustomError) -> Bool {
        switch (lhs, rhs) {
        case (.someError(let lhsMessage), .someError(let rhsMessage)):
            return lhsMessage == rhsMessage
        }
    }
}

enum ArticleNewsViewModelState<T: Equatable>: Equatable {
    case loading
    case loaded(T)
    case failure(CustomError)
    
    static func == (lhs: ArticleNewsViewModelState<T>, rhs: ArticleNewsViewModelState<T>) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case (.loaded(let lhsData), .loaded(let rhsData)):
            return lhsData == rhsData
        case (.failure(let lhsError), .failure(let rhsError)):
            return lhsError == rhsError
        default:
            return false
        }
    }
}

struct FetchNewsToken: Equatable {
    var category: Category
    var token: Date
}


final class ArticleNewsViewModel: ObservableObject {
    @Published var state: ArticleNewsViewModelState<[Article]> = .loading
    @Published var token: FetchNewsToken
    
    private let newsAPI: NewsAPIServiceInterface?
    
    init(articles: [Article]? = nil, newAPI: NewsAPIServiceInterface? = nil, selectedCategory: Category = .general) {
        if let articles {
            state = .loaded(articles)
        } else {
            state = .loading
        }
        self.newsAPI = newAPI
        self.token = FetchNewsToken(category: selectedCategory, token: Date.now)
    }
    
    @MainActor
    func fetchNews() async {
        guard let newsAPI else {
            return
        }
        state = .loading
        do {
            let articles = try await newsAPI.fetchNewsArticles(
                for: token.category
            ).filter{
                $0.title != "[Removed]"
            }
            state = .loaded(articles)
        } catch {
            debugPrint("Failed with error: \(error.localizedDescription)")
            state = .failure(.someError(error.localizedDescription))
        }
    }
}


